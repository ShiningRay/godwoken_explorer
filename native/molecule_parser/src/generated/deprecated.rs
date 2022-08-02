// Generated by Molecule 0.7.2

use super::blockchain::*;
use super::godwoken::*;
use molecule::prelude::*;
#[derive(Clone)]
pub struct DeprecatedMetaContractArgs(molecule::bytes::Bytes);
impl ::core::fmt::LowerHex for DeprecatedMetaContractArgs {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        use molecule::hex_string;
        if f.alternate() {
            write!(f, "0x")?;
        }
        write!(f, "{}", hex_string(self.as_slice()))
    }
}
impl ::core::fmt::Debug for DeprecatedMetaContractArgs {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        write!(f, "{}({:#x})", Self::NAME, self)
    }
}
impl ::core::fmt::Display for DeprecatedMetaContractArgs {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        write!(f, "{}(", Self::NAME)?;
        self.to_enum().display_inner(f)?;
        write!(f, ")")
    }
}
impl ::core::default::Default for DeprecatedMetaContractArgs {
    fn default() -> Self {
        let v: Vec<u8> = vec![
            0, 0, 0, 0, 85, 0, 0, 0, 12, 0, 0, 0, 65, 0, 0, 0, 53, 0, 0, 0, 16, 0, 0, 0, 48, 0, 0,
            0, 49, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0,
        ];
        DeprecatedMetaContractArgs::new_unchecked(v.into())
    }
}
impl DeprecatedMetaContractArgs {
    pub const ITEMS_COUNT: usize = 1;
    pub fn item_id(&self) -> molecule::Number {
        molecule::unpack_number(self.as_slice())
    }
    pub fn to_enum(&self) -> DeprecatedMetaContractArgsUnion {
        let inner = self.0.slice(molecule::NUMBER_SIZE..);
        match self.item_id() {
            0 => CreateAccount::new_unchecked(inner).into(),
            _ => panic!("{}: invalid data", Self::NAME),
        }
    }
    pub fn as_reader<'r>(&'r self) -> DeprecatedMetaContractArgsReader<'r> {
        DeprecatedMetaContractArgsReader::new_unchecked(self.as_slice())
    }
}
impl molecule::prelude::Entity for DeprecatedMetaContractArgs {
    type Builder = DeprecatedMetaContractArgsBuilder;
    const NAME: &'static str = "DeprecatedMetaContractArgs";
    fn new_unchecked(data: molecule::bytes::Bytes) -> Self {
        DeprecatedMetaContractArgs(data)
    }
    fn as_bytes(&self) -> molecule::bytes::Bytes {
        self.0.clone()
    }
    fn as_slice(&self) -> &[u8] {
        &self.0[..]
    }
    fn from_slice(slice: &[u8]) -> molecule::error::VerificationResult<Self> {
        DeprecatedMetaContractArgsReader::from_slice(slice).map(|reader| reader.to_entity())
    }
    fn from_compatible_slice(slice: &[u8]) -> molecule::error::VerificationResult<Self> {
        DeprecatedMetaContractArgsReader::from_compatible_slice(slice)
            .map(|reader| reader.to_entity())
    }
    fn new_builder() -> Self::Builder {
        ::core::default::Default::default()
    }
    fn as_builder(self) -> Self::Builder {
        Self::new_builder().set(self.to_enum())
    }
}
#[derive(Clone, Copy)]
pub struct DeprecatedMetaContractArgsReader<'r>(&'r [u8]);
impl<'r> ::core::fmt::LowerHex for DeprecatedMetaContractArgsReader<'r> {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        use molecule::hex_string;
        if f.alternate() {
            write!(f, "0x")?;
        }
        write!(f, "{}", hex_string(self.as_slice()))
    }
}
impl<'r> ::core::fmt::Debug for DeprecatedMetaContractArgsReader<'r> {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        write!(f, "{}({:#x})", Self::NAME, self)
    }
}
impl<'r> ::core::fmt::Display for DeprecatedMetaContractArgsReader<'r> {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        write!(f, "{}(", Self::NAME)?;
        self.to_enum().display_inner(f)?;
        write!(f, ")")
    }
}
impl<'r> DeprecatedMetaContractArgsReader<'r> {
    pub const ITEMS_COUNT: usize = 1;
    pub fn item_id(&self) -> molecule::Number {
        molecule::unpack_number(self.as_slice())
    }
    pub fn to_enum(&self) -> DeprecatedMetaContractArgsUnionReader<'r> {
        let inner = &self.as_slice()[molecule::NUMBER_SIZE..];
        match self.item_id() {
            0 => CreateAccountReader::new_unchecked(inner).into(),
            _ => panic!("{}: invalid data", Self::NAME),
        }
    }
}
impl<'r> molecule::prelude::Reader<'r> for DeprecatedMetaContractArgsReader<'r> {
    type Entity = DeprecatedMetaContractArgs;
    const NAME: &'static str = "DeprecatedMetaContractArgsReader";
    fn to_entity(&self) -> Self::Entity {
        Self::Entity::new_unchecked(self.as_slice().to_owned().into())
    }
    fn new_unchecked(slice: &'r [u8]) -> Self {
        DeprecatedMetaContractArgsReader(slice)
    }
    fn as_slice(&self) -> &'r [u8] {
        self.0
    }
    fn verify(slice: &[u8], compatible: bool) -> molecule::error::VerificationResult<()> {
        use molecule::verification_error as ve;
        let slice_len = slice.len();
        if slice_len < molecule::NUMBER_SIZE {
            return ve!(Self, HeaderIsBroken, molecule::NUMBER_SIZE, slice_len);
        }
        let item_id = molecule::unpack_number(slice);
        let inner_slice = &slice[molecule::NUMBER_SIZE..];
        match item_id {
            0 => CreateAccountReader::verify(inner_slice, compatible),
            _ => ve!(Self, UnknownItem, Self::ITEMS_COUNT, item_id),
        }?;
        Ok(())
    }
}
#[derive(Debug, Default)]
pub struct DeprecatedMetaContractArgsBuilder(pub(crate) DeprecatedMetaContractArgsUnion);
impl DeprecatedMetaContractArgsBuilder {
    pub const ITEMS_COUNT: usize = 1;
    pub fn set<I>(mut self, v: I) -> Self
    where
        I: ::core::convert::Into<DeprecatedMetaContractArgsUnion>,
    {
        self.0 = v.into();
        self
    }
}
impl molecule::prelude::Builder for DeprecatedMetaContractArgsBuilder {
    type Entity = DeprecatedMetaContractArgs;
    const NAME: &'static str = "DeprecatedMetaContractArgsBuilder";
    fn expected_length(&self) -> usize {
        molecule::NUMBER_SIZE + self.0.as_slice().len()
    }
    fn write<W: molecule::io::Write>(&self, writer: &mut W) -> molecule::io::Result<()> {
        writer.write_all(&molecule::pack_number(self.0.item_id()))?;
        writer.write_all(self.0.as_slice())
    }
    fn build(&self) -> Self::Entity {
        let mut inner = Vec::with_capacity(self.expected_length());
        self.write(&mut inner)
            .unwrap_or_else(|_| panic!("{} build should be ok", Self::NAME));
        DeprecatedMetaContractArgs::new_unchecked(inner.into())
    }
}
#[derive(Debug, Clone)]
pub enum DeprecatedMetaContractArgsUnion {
    CreateAccount(CreateAccount),
}
#[derive(Debug, Clone, Copy)]
pub enum DeprecatedMetaContractArgsUnionReader<'r> {
    CreateAccount(CreateAccountReader<'r>),
}
impl ::core::default::Default for DeprecatedMetaContractArgsUnion {
    fn default() -> Self {
        DeprecatedMetaContractArgsUnion::CreateAccount(::core::default::Default::default())
    }
}
impl ::core::fmt::Display for DeprecatedMetaContractArgsUnion {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(ref item) => {
                write!(f, "{}::{}({})", Self::NAME, CreateAccount::NAME, item)
            }
        }
    }
}
impl<'r> ::core::fmt::Display for DeprecatedMetaContractArgsUnionReader<'r> {
    fn fmt(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        match self {
            DeprecatedMetaContractArgsUnionReader::CreateAccount(ref item) => {
                write!(f, "{}::{}({})", Self::NAME, CreateAccount::NAME, item)
            }
        }
    }
}
impl DeprecatedMetaContractArgsUnion {
    pub(crate) fn display_inner(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(ref item) => write!(f, "{}", item),
        }
    }
}
impl<'r> DeprecatedMetaContractArgsUnionReader<'r> {
    pub(crate) fn display_inner(&self, f: &mut ::core::fmt::Formatter) -> ::core::fmt::Result {
        match self {
            DeprecatedMetaContractArgsUnionReader::CreateAccount(ref item) => write!(f, "{}", item),
        }
    }
}
impl ::core::convert::From<CreateAccount> for DeprecatedMetaContractArgsUnion {
    fn from(item: CreateAccount) -> Self {
        DeprecatedMetaContractArgsUnion::CreateAccount(item)
    }
}
impl<'r> ::core::convert::From<CreateAccountReader<'r>>
    for DeprecatedMetaContractArgsUnionReader<'r>
{
    fn from(item: CreateAccountReader<'r>) -> Self {
        DeprecatedMetaContractArgsUnionReader::CreateAccount(item)
    }
}
impl DeprecatedMetaContractArgsUnion {
    pub const NAME: &'static str = "DeprecatedMetaContractArgsUnion";
    pub fn as_bytes(&self) -> molecule::bytes::Bytes {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(item) => item.as_bytes(),
        }
    }
    pub fn as_slice(&self) -> &[u8] {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(item) => item.as_slice(),
        }
    }
    pub fn item_id(&self) -> molecule::Number {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(_) => 0,
        }
    }
    pub fn item_name(&self) -> &str {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(_) => "CreateAccount",
        }
    }
    pub fn as_reader<'r>(&'r self) -> DeprecatedMetaContractArgsUnionReader<'r> {
        match self {
            DeprecatedMetaContractArgsUnion::CreateAccount(item) => item.as_reader().into(),
        }
    }
}
impl<'r> DeprecatedMetaContractArgsUnionReader<'r> {
    pub const NAME: &'r str = "DeprecatedMetaContractArgsUnionReader";
    pub fn as_slice(&self) -> &'r [u8] {
        match self {
            DeprecatedMetaContractArgsUnionReader::CreateAccount(item) => item.as_slice(),
        }
    }
    pub fn item_id(&self) -> molecule::Number {
        match self {
            DeprecatedMetaContractArgsUnionReader::CreateAccount(_) => 0,
        }
    }
    pub fn item_name(&self) -> &str {
        match self {
            DeprecatedMetaContractArgsUnionReader::CreateAccount(_) => "CreateAccount",
        }
    }
}
