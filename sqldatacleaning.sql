-----CLEANING DATA IN SQL-----

SELECT * FROM NASHVILLEHOUSING

------------CONVERT THE DATE FORMAT-------
SELECT saledateconverted,convert(date,saledate)
FROM NASHVILLEHOUSING

UPDATE NASHVILLEHOUSING 
SET SALEDATE=CONVERT(DATE, SALEDATE)

ALTER TABLE NASHVILLEHOUSING 
add saledateconverted date


update nashvillehousing 
set saledateconverted=convert(date, saledate)


------------------------populate property address data-----------

select *
from nashvillehousing
where propertyaddress is null


select a.ParcelID,a.PropertyAddress,b.parcelid,b.propertyaddress, isnull(a.PropertyAddress,b.propertyaddress)
from nashvillehousing a
join  nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.propertyaddress)
from nashvillehousing a
join  nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

--------breaking out address in individual column(Address,City, State)---------------


select propertyaddress
from nashvillehousing  ------if we see the output the data has been seperated by comma-----

select
substring(propertyaddress,1,charindex(',',propertyaddress)-1)
from NASHVILLEHOUSING

select
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address1,
substring(propertyaddress,charindex(',',propertyaddress)+1, len(propertyaddress)) as address2
from NASHVILLEHOUSING


ALTER TABLE NASHVILLEHOUSING 
add PropertySplitAddress nvarchar(255)


update nashvillehousing 
set PropertySplitAddress=substring(propertyaddress,1,charindex(',',propertyaddress)-1)


ALTER TABLE NASHVILLEHOUSING 
add PropertySplitCity nvarchar(255)

update nashvillehousing 
set PropertySplitCity=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select * from NASHVILLEHOUSING


----------------split the data fom owner address-----------------
--1. We can use PARSENAME to split the value
--2.it uses . to identify the seperation instead of , / \
----3. it works in backword direction 



select
parsename(owneraddress,1)
from NASHVILLEHOUSING  ---It will give no change because parsename recognises only . not ,

select
parsename(Replace(owneraddress,',','.'),3),
parsename(Replace(owneraddress,',','.'),2),
parsename(Replace(owneraddress,',','.'),1)
from NASHVILLEHOUSING

ALTER TABLE NASHVILLEHOUSING 
add OwnerSplitAddress nvarchar(255)


update nashvillehousing 
set  OwnerSplitAddress=parsename(Replace(owneraddress,',','.'),3)


ALTER TABLE NASHVILLEHOUSING 
add  OwnerSplitCity nvarchar(255)

update nashvillehousing 
set  OwnerSplitCity=parsename(Replace(owneraddress,',','.'),2)

ALTER TABLE NASHVILLEHOUSING 
add  OwnerSplitstate nvarchar(255)

update nashvillehousing 
set  OwnerSplitstate=parsename(Replace(owneraddress,',','.'),1)

select * from NASHVILLEHOUSING


-------change Y and N to YES and NO in SoldAsVacant column-----

SELECT DISTINCT (SoldAsVacant),count(SoldAsVacant)
from NASHVILLEHOUSING
group by SoldAsVacant
order by 2



select soldasvacant,
case when soldasvacant = 'Y' THEN 'YES'
	WHEN soldasvacant = 'N' THEN 'NO'
	ELSE SOLDASVACANT
	END
FROM NASHVILLEHOUSING

UPDATE NASHVILLEHOUSING
SET SOLDASVACANT = case when soldasvacant = 'Y' THEN 'YES'
	WHEN soldasvacant = 'N' THEN 'NO'
	ELSE SOLDASVACANT
	END

-------REMOVING DUPLICATES-------

SELECT * FROM NASHVILLEHOUSING


with RowNumCTE as(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY  ParcelID,
				PropertyAddress,
				saleprice,
				saledate,
				legalreference
				order by UniqueId ) row_num
from NASHVILLEHOUSING
----order by ParcelID
)

Delete
from RowNumCTE 
where row_num >1
--order by propertyaddress

-----------------------------delete unused columns------------------------

select * from NASHVILLEHOUSING


alter table nashvillehousing
drop column propertyaddress, owneraddress, taxdistrict

alter table nashvillehousing
drop column saledate


---------------THE END----------------
