namespace cpp rtdbc.thrift
namespace java rtdbc.thrift
namespace py rtdbc

enum DataType
{
	DIGITAL = 0,
	INTEGER,
	DOUBLE,
	STRING,
	BLOB,
}

enum DataQuality
{
	GOOD = 0,       //好
	BAD,            //坏
	UNCERTAIN,      //可疑
	NA,             //未定义
}

union Value
{
	1: i64 Integer,
	2: double Double,
	3: string String,
	4: binary Blob,
}

struct Error
{
	1: required i64 commonError,
	2: optional i64 nativeError,
}

struct DataSample
{
	1: required string tagname,
	2: required double timestamp,
	3: required DataType type,
	4: required Value value,
	5: required DataQuality dataQuality,
}

struct DataRecord
{
	1: required DataSample dataSample,
	2: required Error error,
}

enum SamplingMode
{
    INTERPOLATED = 0,
    TREND,
}

exception IOError {
    1: required Error error,
    2: optional string message,
}

exception IllegalArgument {
    1: required Error error,
    2: optional string message,
}

service RTDBCService {
    list<DataRecord> readCurrentDatas(1:list<string> tagnames) throws (1:IOError io, 2:IllegalArgument ia),
    list<DataRecord> readInterpolatedDatas(1:list<string> tagnames, 2:list<double> timestamps) throws (1:IOError io, 2:IllegalArgument ia),
    list<DataSample> readRawDatas(1:string tagname, 2:double startTime, 3:double endTime) throws (1:IOError io, 2:IllegalArgument ia),
    list<DataSample> readSampledDatas(1:string tagname, 2:double startTime, 3:double endTime, 4:SamplingMode mode, 5:i64 intervalMilliseconds) throws (1:IOError io, 2:IllegalArgument ia),
    list<Error> writeDatas(1:list<DataSample> dataSamples) throws (1:IOError io, 2:IllegalArgument ia),
}
