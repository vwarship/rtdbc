namespace cpp rtdbc.thrift
namespace java rtdbc.thrift
namespace py rtdbc

enum DataType
{
	DIGITAL = 1,
	INT16,
	INT32,
	FLOAT32,
	FLOAT64,
	TIMESTAMP,
	STRING,
	BLOB,
}

enum DataQuality
{
	GOOD = 0,       //好
	BAD,            //坏
	UNCERTAIN,      //可疑
	UNDEFINED,      //未定义
}

enum SamplingMode
{
    INTERPOLATED = 1,
    TREND,
}

struct Error
{
	1: required i32 commonError,
	2: optional i32 nativeError,
	3: optional string message,
}

struct Data
{
	1: required string tagname,
	2: required double timestamp,
	3: required DataType type,
	4: required double value,
	5: required DataQuality dataQuality,
	6: optional Error error,
}

exception IOError {
  1: optional string message,
}

exception IllegalArgument {
  1: optional string message,
}

service RTDBCService {
    list<Data> readCurrentData(1:list<string> tagnames) throws (1:IOError io, 2:IllegalArgument ia),
    list<Data> readInterpolatedData(1:list<string> tagnames, 2:list<double> timestamps) throws (1:IOError io, 2:IllegalArgument ia),
    list<Data> readRawData(1:string tagname, 2:double startTime, 3:double endTime) throws (1:IOError io, 2:IllegalArgument ia),
    list<Data> readSampledData(1:string tagname, 2:double startTime, 3:double endTime, 4:SamplingMode mode, 5:i64 intervalMilliseconds) throws (1:IOError io, 2:IllegalArgument ia),
    list<Error> writeData(1:list<Data> datas) throws (1:IOError io, 2:IllegalArgument ia),
}
