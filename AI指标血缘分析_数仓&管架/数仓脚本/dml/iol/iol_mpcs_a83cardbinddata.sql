/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a83cardbinddata
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
drop table ${iol_schema}.mpcs_a83cardbinddata_ex purge;
alter table ${iol_schema}.mpcs_a83cardbinddata add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a83cardbinddata;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a83cardbinddata_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a83cardbinddata where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a83cardbinddata_ex(
    custno -- 客户号
    ,opendate -- 用户开户日期
    ,qyjhdate -- 用户权益激活时间
    ,yshacctno -- 映山红卡号
    ,yshacctclass -- 映山红卡等级 0-映山红卡 1-映山红钻石卡
    ,ltacctno -- 龙腾卡卡号
    ,ltacctclass -- 龙腾卡等级 0-白金 1-钻石
    ,ltacctpw -- 龙腾卡初始密码
    ,iptftp -- 用户证件类型
    ,iptfno -- 类型证件号码
    ,sex -- 性别 F-女 M-男
    ,custname -- 客户姓名
    ,custphone -- 客户手机号
    ,openuser -- 操作柜员
    ,openbrchno -- 开户机构
    ,custaddr -- 客户地址
    ,acctstate -- 卡状态 0 正常  2注销 3 挂失 4挂失未激活（网银侧使用）
    ,qystate -- 权益状态 0 正常 1 冻结 2 注销
    ,opentag -- 开卡方式 0-  资产达标 1-  特批开卡
    ,amtsettag -- 管理费收取 0-收管理费 1-一年内免收 2-两年内免收 3-三年内免收 4-终身免费
    ,amtenddate -- 免费终止日期
    ,accountno -- 管理费核算机构 0-总行 1-分行
    ,remark -- 特批说明
    ,acctamt -- 冻结，欠费金额
    ,acctoperdate -- 冻结解冻日期
    ,acctnochg -- 换卡-前映山红卡号
    ,acctstatechg -- 换卡-前映山红卡级别
    ,amtfeetag -- 批量扣收管理费结果状态 0-成功 1-初次批扣失败 2-补扣失败
    ,acctfreesum -- 用户被冻结次数；初始值为0
    ,transtag -- 1 非映山红卡换映山红卡,2 映山红卡换非映山红卡,3 同等级换卡,4 升级换卡 5 降级换卡 6-注销 7-解挂补开 8-管理费标识维护
    ,dealdate -- 操作日期
    ,remark1 -- 
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,remark5 -- 
    ,remark6 -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    custno -- 客户号
    ,opendate -- 用户开户日期
    ,qyjhdate -- 用户权益激活时间
    ,yshacctno -- 映山红卡号
    ,yshacctclass -- 映山红卡等级 0-映山红卡 1-映山红钻石卡
    ,ltacctno -- 龙腾卡卡号
    ,ltacctclass -- 龙腾卡等级 0-白金 1-钻石
    ,ltacctpw -- 龙腾卡初始密码
    ,iptftp -- 用户证件类型
    ,iptfno -- 类型证件号码
    ,sex -- 性别 F-女 M-男
    ,custname -- 客户姓名
    ,custphone -- 客户手机号
    ,openuser -- 操作柜员
    ,openbrchno -- 开户机构
    ,custaddr -- 客户地址
    ,acctstate -- 卡状态 0 正常  2注销 3 挂失 4挂失未激活（网银侧使用）
    ,qystate -- 权益状态 0 正常 1 冻结 2 注销
    ,opentag -- 开卡方式 0-  资产达标 1-  特批开卡
    ,amtsettag -- 管理费收取 0-收管理费 1-一年内免收 2-两年内免收 3-三年内免收 4-终身免费
    ,amtenddate -- 免费终止日期
    ,accountno -- 管理费核算机构 0-总行 1-分行
    ,remark -- 特批说明
    ,acctamt -- 冻结，欠费金额
    ,acctoperdate -- 冻结解冻日期
    ,acctnochg -- 换卡-前映山红卡号
    ,acctstatechg -- 换卡-前映山红卡级别
    ,amtfeetag -- 批量扣收管理费结果状态 0-成功 1-初次批扣失败 2-补扣失败
    ,acctfreesum -- 用户被冻结次数；初始值为0
    ,transtag -- 1 非映山红卡换映山红卡,2 映山红卡换非映山红卡,3 同等级换卡,4 升级换卡 5 降级换卡 6-注销 7-解挂补开 8-管理费标识维护
    ,dealdate -- 操作日期
    ,remark1 -- 
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,remark5 -- 
    ,remark6 -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a83cardbinddata
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a83cardbinddata exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a83cardbinddata_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a83cardbinddata to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a83cardbinddata_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a83cardbinddata',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);