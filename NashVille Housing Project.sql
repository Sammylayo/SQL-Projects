select top 50 *
from ProjectPortfolio..NashvilleHousing


--Standardize the date
alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = cast(SaleDate as date) 

select SaleDateConverted, SaleDate
from ProjectPortfolio..NashvilleHousing 


--populate property address data
select *
from ProjectPortfolio..NashvilleHousing 
--where propertyaddress is null
order by ParcelID


select a.UniqueID, a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from ProjectPortfolio..NashvilleHousing a
join ProjectPortfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID

select top 5 *
from ProjectPortfolio..NashvilleHousing


--Standardize the date
alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = cast(SaleDate as date) 

select SaleDateConverted
from ProjectPortfolio..NashvilleHousing 


--populate property address data
select *
from ProjectPortfolio..NashvilleHousing 
--where propertyaddress is null
order by ParcelID

select a.UniqueID, a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from ProjectPortfolio..NashvilleHousing a
join ProjectPortfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
	where a.PropertyAddress is null 


Update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectPortfolio..NashvilleHousing a
join ProjectPortfolio..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null 


select 
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as address, 
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress)) as address2, PropertyAddress
from ProjectPortfolio..NashvilleHousing 

alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add Address1 nvarchar(255);

update NashvilleHousing
set Address1 = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add Address2 nvarchar(255);

update NashvilleHousing
set Address2 = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, len(PropertyAddress))

select PropertyAddress, Address1, Address2
from ProjectPortfolio..NashvilleHousing 




select OwnerAddress,
parsename(replace(OwnerAddress, ',','.'), 3), 
parsename(replace(OwnerAddress, ',','.'), 2), 
parsename(replace(OwnerAddress, ',','.'), 1)
from ProjectPortfolio..NashvilleHousing

alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add Address3 nvarchar(255);

update NashvilleHousing
set Address3 = parsename(replace(OwnerAddress, ',','.'), 3)

alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add Address4 nvarchar(255);

update NashvilleHousing
set Address4 = parsename(replace(OwnerAddress, ',','.'), 2)

alter table NashvilleHousing --to add A NEW COLUMN TO THE TABLE
add Address5 nvarchar(255);

update NashvilleHousing
set Address5 = parsename(replace(OwnerAddress, ',','.'), 1)


select OwnerAddress, Address3, Address4, Address5
from ProjectPortfolio..NashvilleHousing


select distinct(SoldAsVacant), count(SoldAsVacant)
from ProjectPortfolio..NashvilleHousing
group by SoldAsVacant

select SoldAsVacant,
case 
	when SoldAsVacant = 'N' then 'No' 
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
end as SoldAsVacant2
from ProjectPortfolio..NashvilleHousing
 
alter table NashvilleHousing
add SoldAsVacant2 nvarchar(255)

update NashvilleHousing
set SoldAsVacant2 = case 
	when SoldAsVacant = 'N' then 'No' 
	when SoldAsVacant = 'Y' then 'Yes'
	else SoldAsVacant
end

select *
from ProjectPortfolio..NashvilleHousing
 














































