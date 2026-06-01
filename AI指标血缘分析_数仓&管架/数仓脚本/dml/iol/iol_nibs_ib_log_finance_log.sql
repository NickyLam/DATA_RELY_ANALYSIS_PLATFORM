/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_finance_log
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_finance_log_ex purge;
alter table ${iol_schema}.nibs_ib_log_finance_log add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_ib_log_finance_log truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ib_log_finance_log_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_finance_log where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ib_log_finance_log_ex(
    tx_seq -- 业务流水号
    ,financestatus -- 业务登记标识|0-登记 1-关联
    ,trandate -- 交易日期
    ,trantim -- 交易时间
    ,trancode -- 交易码
    ,branchnum -- 机构号
    ,usernum -- 柜员号
    ,actflag -- 是否代理|n-否 1-普通代理 2-监护人代理
    ,servicecontent -- 服务内容
    ,tranccy -- 付出币种
    ,tranamt -- 付出金额
    ,drawccy -- 收入币种
    ,drawamt -- 收入金额
    ,applyname -- 申请人姓名
    ,applysex -- 申请人性别
    ,applybirthday -- 申请人出生日期
    ,applycountry -- 申请人国籍
    ,applycerttype -- 申请人证件类型
    ,applycertnum -- 申请人证件号码
    ,applycertsta -- 申请人证件开始日期
    ,applycertend -- 申请人证件结束日期
    ,certbranchnum -- 发证机关代码
    ,certbranchaddr -- 发证机关地区
    ,loc -- 工作单位
    ,postcode -- 邮编
    ,telephone -- 固定电话
    ,phone -- 移动电话
    ,actnaem -- 代理人姓名
    ,actcountry -- 代理人国籍
    ,actcerttyp -- 代理人证件类型
    ,actcertnum -- 代理人证件号码
    ,actcertsta -- 代理人证件开始日期
    ,actcertend -- 代理人证件结束日期
    ,acttelephone -- 代理人固定电话
    ,actphone -- 代理人移动电话
    ,actreason -- 代理原因
    ,careerone -- 职业一级
    ,careertwo -- 职业二级
    ,careeronename -- 职业一级名称
    ,careertwoname -- 职业二级名称
    ,careerdesc -- 职业说明
    ,cretaddrflag -- 居住地是否同证件|1-是 0-否
    ,cretprovincecode -- 证件省代码
    ,cretcitycode -- 证件市代码
    ,cretcountycode -- 证件区代码
    ,cretprovincename -- 证件省名称
    ,cretcityname -- 证件市名称
    ,cretcountyname -- 证件区名称
    ,cretaddresdesc -- 证件联系地址
    ,provincecode -- 常住省代码
    ,citycode -- 常住市代码
    ,countycode -- 常住区代码
    ,provincename -- 常住省名称
    ,cityname -- 常住市名称
    ,countyname -- 常住区名称
    ,addresdesc -- 常住联系地址
    ,remark1 -- 备用1
    ,remark2 -- 备用2
    ,remark3 -- 备用3
    ,remark4 -- 备用4
    ,remark5 -- 备用5
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tx_seq -- 业务流水号
    ,financestatus -- 业务登记标识|0-登记 1-关联
    ,trandate -- 交易日期
    ,trantim -- 交易时间
    ,trancode -- 交易码
    ,branchnum -- 机构号
    ,usernum -- 柜员号
    ,actflag -- 是否代理|n-否 1-普通代理 2-监护人代理
    ,servicecontent -- 服务内容
    ,tranccy -- 付出币种
    ,tranamt -- 付出金额
    ,drawccy -- 收入币种
    ,drawamt -- 收入金额
    ,applyname -- 申请人姓名
    ,applysex -- 申请人性别
    ,applybirthday -- 申请人出生日期
    ,applycountry -- 申请人国籍
    ,applycerttype -- 申请人证件类型
    ,applycertnum -- 申请人证件号码
    ,applycertsta -- 申请人证件开始日期
    ,applycertend -- 申请人证件结束日期
    ,certbranchnum -- 发证机关代码
    ,certbranchaddr -- 发证机关地区
    ,loc -- 工作单位
    ,postcode -- 邮编
    ,telephone -- 固定电话
    ,phone -- 移动电话
    ,actnaem -- 代理人姓名
    ,actcountry -- 代理人国籍
    ,actcerttyp -- 代理人证件类型
    ,actcertnum -- 代理人证件号码
    ,actcertsta -- 代理人证件开始日期
    ,actcertend -- 代理人证件结束日期
    ,acttelephone -- 代理人固定电话
    ,actphone -- 代理人移动电话
    ,actreason -- 代理原因
    ,careerone -- 职业一级
    ,careertwo -- 职业二级
    ,careeronename -- 职业一级名称
    ,careertwoname -- 职业二级名称
    ,careerdesc -- 职业说明
    ,cretaddrflag -- 居住地是否同证件|1-是 0-否
    ,cretprovincecode -- 证件省代码
    ,cretcitycode -- 证件市代码
    ,cretcountycode -- 证件区代码
    ,cretprovincename -- 证件省名称
    ,cretcityname -- 证件市名称
    ,cretcountyname -- 证件区名称
    ,cretaddresdesc -- 证件联系地址
    ,provincecode -- 常住省代码
    ,citycode -- 常住市代码
    ,countycode -- 常住区代码
    ,provincename -- 常住省名称
    ,cityname -- 常住市名称
    ,countyname -- 常住区名称
    ,addresdesc -- 常住联系地址
    ,remark1 -- 备用1
    ,remark2 -- 备用2
    ,remark3 -- 备用3
    ,remark4 -- 备用4
    ,remark5 -- 备用5
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ib_log_finance_log
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_ib_log_finance_log exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_log_finance_log_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_finance_log to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ib_log_finance_log_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_finance_log',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);