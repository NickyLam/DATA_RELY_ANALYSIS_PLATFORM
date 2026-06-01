/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a49tefrepsign
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
drop table ${iol_schema}.mpcs_a49tefrepsign_ex purge;
alter table ${iol_schema}.mpcs_a49tefrepsign add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.mpcs_a49tefrepsign;

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a49tefrepsign_ex nologging
compress
as
select * from ${iol_schema}.mpcs_a49tefrepsign where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a49tefrepsign_ex(
    signdt -- 
    ,signsq -- 
    ,signtm -- 
    ,iotype -- 来往标记(I/O)
    ,deptcd -- 组织机构代码
    ,deptnm -- 组织机构名称
    ,protocolno -- 协议号
    ,userno -- 用户编号
    ,username -- 用户名称
    ,contactusername -- 联系人姓名
    ,contactuseraddr -- 联系人地址
    ,postcode -- 联系人地址邮编
    ,contactusertel -- 联系人电话
    ,trantype -- 业务种类
    ,openbrch -- 付款人开户机构
    ,payerbank -- 付款行行号
    ,openbrno -- 付款人开户行行号
    ,payeracc -- 付款人账号
    ,payername -- 付款人户名
    ,payeridtype -- 付款人证件类型
    ,payerid -- 付款人证件号码
    ,payermobile -- 付款人电话
    ,payeremail -- 付款人信箱
    ,payeename -- 收款人名称
    ,msgid -- 
    ,ormsgid -- 
    ,remark -- 
    ,brchno -- 
    ,userid -- 
    ,ckbkus -- 
    ,frsgdt -- 
    ,frsgsq -- 
    ,upsgdt -- 
    ,upsgsq -- 
    ,upbrch -- 
    ,upurid -- 
    ,upckus -- 
    ,signst -- 00 签约成功 01发送失败 02发送成功 03已撤销 04撤销发送成功 05签约失败
    ,updttm -- 
    ,prtnum -- 
    ,retcd -- 人行返回码
    ,errmsg -- 人行返回详细信息
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    signdt -- 
    ,signsq -- 
    ,signtm -- 
    ,iotype -- 来往标记(I/O)
    ,deptcd -- 组织机构代码
    ,deptnm -- 组织机构名称
    ,protocolno -- 协议号
    ,userno -- 用户编号
    ,username -- 用户名称
    ,contactusername -- 联系人姓名
    ,contactuseraddr -- 联系人地址
    ,postcode -- 联系人地址邮编
    ,contactusertel -- 联系人电话
    ,trantype -- 业务种类
    ,openbrch -- 付款人开户机构
    ,payerbank -- 付款行行号
    ,openbrno -- 付款人开户行行号
    ,payeracc -- 付款人账号
    ,payername -- 付款人户名
    ,payeridtype -- 付款人证件类型
    ,payerid -- 付款人证件号码
    ,payermobile -- 付款人电话
    ,payeremail -- 付款人信箱
    ,payeename -- 收款人名称
    ,msgid -- 
    ,ormsgid -- 
    ,remark -- 
    ,brchno -- 
    ,userid -- 
    ,ckbkus -- 
    ,frsgdt -- 
    ,frsgsq -- 
    ,upsgdt -- 
    ,upsgsq -- 
    ,upbrch -- 
    ,upurid -- 
    ,upckus -- 
    ,signst -- 00 签约成功 01发送失败 02发送成功 03已撤销 04撤销发送成功 05签约失败
    ,updttm -- 
    ,prtnum -- 
    ,retcd -- 人行返回码
    ,errmsg -- 人行返回详细信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a49tefrepsign
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a49tefrepsign exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a49tefrepsign_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a49tefrepsign to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a49tefrepsign_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a49tefrepsign',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);