/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1xacctinfo
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
drop table ${iol_schema}.mpcs_a1xacctinfo_ex purge;
alter table ${iol_schema}.mpcs_a1xacctinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a1xacctinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a1xacctinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1xacctinfo where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a1xacctinfo_ex(
    fntdt -- 渠道日期
    ,phoneno -- 手机号
    ,customid -- 客户ID
    ,acctno -- 账号
    ,custno -- 客户号
    ,issinscode -- 开户行机构代码
    ,txnno -- 银联开户交易流水号
    ,txntm -- 开户日期
    ,bussid -- 业务类别 1：旅行通卡业务 2：福旅通业务
    ,elemmode -- 开户要素模式
    ,idcardtyp -- 证件类型
    ,certifid1 -- 证件号1
    ,certifid2 -- 证件号2
    ,familynm -- 姓
    ,firstnm -- 名
    ,custna -- 姓名
    ,sex -- 性别
    ,birthday -- 出生日期
    ,nationality -- 国籍
    ,occupation -- 职业
    ,ocpdsc -- 职业描述
    ,taxresidenttype -- 税收居民身份
    ,address -- 联系地址
    ,validstart -- 身份证件发证日期
    ,validuntil -- 身份证件有效期
    ,photoqryid -- 影印件采集交易的查询流水号
    ,provincecode -- 省代码
    ,citycode -- 市代码
    ,districtcode -- 区代码
    ,crsresidenttaxnation -- 税收居民国/地区
    ,crsresidenttaxid -- 居民国/地区纳税人识别号
    ,crstaxntnungetreason -- 不能提供居民国/地区纳税人识别号的原因
    ,crstaxidungetreason -- 具体原因
    ,entrychannel -- 入境渠道
    ,verifyresult -- 信源核验结果
    ,channelid -- 申卡渠道ID
    ,channelname -- 申卡渠道名称
    ,globalseq -- 开户全局流水号
    ,status -- 状态
    ,degree -- 账户等级
    ,subaccprd -- 旅行通卡有效期
    ,limitamt -- 旅行通卡限额
    ,sumamt -- 累计充值金额
    ,tkamt -- 退卡账户余额，即退卡账户转清算户交易金额
    ,updatetm -- 最新维护时间
    ,unsigndt -- 解约日期
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,remark6 -- 备注6
    ,remark7 -- 备注7
    ,remark8 -- 备注8
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    fntdt -- 渠道日期
    ,phoneno -- 手机号
    ,customid -- 客户ID
    ,acctno -- 账号
    ,custno -- 客户号
    ,issinscode -- 开户行机构代码
    ,txnno -- 银联开户交易流水号
    ,txntm -- 开户日期
    ,bussid -- 业务类别 1：旅行通卡业务 2：福旅通业务
    ,elemmode -- 开户要素模式
    ,idcardtyp -- 证件类型
    ,certifid1 -- 证件号1
    ,certifid2 -- 证件号2
    ,familynm -- 姓
    ,firstnm -- 名
    ,custna -- 姓名
    ,sex -- 性别
    ,birthday -- 出生日期
    ,nationality -- 国籍
    ,occupation -- 职业
    ,ocpdsc -- 职业描述
    ,taxresidenttype -- 税收居民身份
    ,address -- 联系地址
    ,validstart -- 身份证件发证日期
    ,validuntil -- 身份证件有效期
    ,photoqryid -- 影印件采集交易的查询流水号
    ,provincecode -- 省代码
    ,citycode -- 市代码
    ,districtcode -- 区代码
    ,crsresidenttaxnation -- 税收居民国/地区
    ,crsresidenttaxid -- 居民国/地区纳税人识别号
    ,crstaxntnungetreason -- 不能提供居民国/地区纳税人识别号的原因
    ,crstaxidungetreason -- 具体原因
    ,entrychannel -- 入境渠道
    ,verifyresult -- 信源核验结果
    ,channelid -- 申卡渠道ID
    ,channelname -- 申卡渠道名称
    ,globalseq -- 开户全局流水号
    ,status -- 状态
    ,degree -- 账户等级
    ,subaccprd -- 旅行通卡有效期
    ,limitamt -- 旅行通卡限额
    ,sumamt -- 累计充值金额
    ,tkamt -- 退卡账户余额，即退卡账户转清算户交易金额
    ,updatetm -- 最新维护时间
    ,unsigndt -- 解约日期
    ,remark1 -- 备注1
    ,remark2 -- 备注2
    ,remark3 -- 备注3
    ,remark4 -- 备注4
    ,remark5 -- 备注5
    ,remark6 -- 备注6
    ,remark7 -- 备注7
    ,remark8 -- 备注8
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a1xacctinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a1xacctinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1xacctinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1xacctinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a1xacctinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1xacctinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);