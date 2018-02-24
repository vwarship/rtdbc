namespace cpp com.gouchicao.rtdbc.thrift
namespace java com.gouchicao.rtdbc
namespace csharp RTDBC
namespace py rtdbc

enum DataType {
	INTEGER,
	DOUBLE,
}

enum DataQuality {
	GOOD,           //好
	BAD,            //坏
}

enum SamplingMode {
    INTERPOLATED = 1,
    TREND,
}

struct DataSample {
	1: required string tagname,
	2: required double timestamp,
	3: required double value,
	4: required DataType type,
	5: required DataQuality data_quality,
}

/** 非法请求，如：参数格式不正确或者不完整 */
exception InvalidRequestException {
    1: optional string why,
}

service RTDBCService {
    list<DataSample> read_current_datas(1:required list<string> tagnames)
        throws (1:InvalidRequestException ire),
        
    list<DataSample> read_interpolated_datas(1:required list<string> tagnames, 
                                             2:required double timestamp)
        throws (1:InvalidRequestException ire),
        
    list<DataSample> read_raw_datas(1:required string tagname, 
                                    2:required double start_time, 
                                    3:required double end_time)
        throws (1:InvalidRequestException ire),
        
    list<DataSample> read_sampled_datas(1:required string tagname, 
                                        2:required double start_time, 
                                        3:required double end_time, 
                                        4:required i64 number_of_samples, 
                                        5:required SamplingMode mode=SamplingMode.INTERPOLATED)
        throws (1:InvalidRequestException ire),
    
    list<DataQuality> write_datas(1:required list<DataSample> data_samples)
        throws (1:InvalidRequestException ire),
}
