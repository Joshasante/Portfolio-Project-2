select *
from nashvillehousing

select saledate
from nashvillehousing

--Standardize Date Format

select saledate, convert(Date,saledate)
from nashvillehousing

update NashvilleHousing
set saledateconverted = convert(Date, Saledate)

Alter table nashvillehousing
Add saledateconverted date

Update NashvilleHousing
set saledateconverted = convert(Date,saledate)

--Populate PropertyAddress

select PropertyAddress
from nashvillehousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from nashvillehousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from nashvillehousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

--Breaking out Address into Individual columns (Address, City, State)

select PropertyAddress
from nashvillehousing
--where PropertyAddress is null
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress)) as Address
from NashvilleHousing

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing

Alter table nashvillehousing
Add PropertysplitAddress nvarchar(255);

Update NashvilleHousing
set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyaddress) -1);

Alter table nashvillehousing
Add PropertysplitCity nvarchar(255);

Update NashvilleHousing
set PropertysplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyaddress) +1, LEN(PropertyAddress))

Select *
from NashvilleHousing

Select OwnerAddress
from NashvilleHousing

select
PARSENAME(Replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(Replace(OwnerAddress, ',', '.') ,1)
from NashvilleHousing

Alter table nashvillehousing
Add OwnersplitAddress nvarchar(255);

Update NashvilleHousing
set OwnersplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.') ,3);

Alter table nashvillehousing
Add OwnersplitCity nvarchar(255);

Update NashvilleHousing
set OwnersplitCity = PARSENAME(Replace(OwnerAddress, ',', '.') ,2)

Alter table nashvillehousing
Add OwnersplitState nvarchar(255);

Update NashvilleHousing
set OwnersplitState = PARSENAME(Replace(OwnerAddress, ',', '.') ,1)

Select *
from NashvilleHousing

Select distinct(SoldAsVacant), count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant


select SoldAsVacant,
	case when soldasvacant = 'Y' then 'Yes'
		 when soldasvacant = 'N' then 'No'
		 else soldasvacant
		 end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
		 when soldasvacant = 'N' then 'No'
		 else soldasvacant
		 end
from NashvilleHousing


--Remove Duplicates

With RowNumCTE AS(
Select *,
	Row_Number() over (
	Partition by parcelid,
				propertyaddress,
				saledate,
				legalreference
				order by
				uniqueid
				) row_num
from NashvilleHousing
--order by parcelid
)
SELECT *
FROM ROWNUMCTE
Where row_num > 1
Order by propertyAddress


With RowNumCTE AS(
Select *,
	Row_Number() over (
	Partition by parcelid,
				propertyaddress,
				saledate,
				legalreference
				order by
				uniqueid
				) row_num
from NashvilleHousing
--order by parcelid
)
Delete
FROM ROWNUMCTE
Where row_num > 1
--Order by propertyAddress



--Delete Unused Columns

select *
from NashvilleHousing

Alter Table NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashvilleHousing
Drop column Saledate