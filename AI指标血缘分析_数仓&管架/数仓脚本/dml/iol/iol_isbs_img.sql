/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_img
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
drop table ${iol_schema}.isbs_img_ex purge;
alter table ${iol_schema}.isbs_img add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.isbs_img;

-- 2.3 insert data to ex table
create table ${iol_schema}.isbs_img_ex nologging
compress
as
select * from ${iol_schema}.isbs_img where 0=1;

insert /*+ append */ into ${iol_schema}.isbs_img_ex(
    inr -- 数据序号
    ,msgid -- 报文标识号
    ,objtyp -- 关联业务表类型
    ,objinr -- 关联业务表INR
    ,fileid -- 人行回传影像ID
    ,filnam -- 影像名称
    ,filpth -- 文件存放路径
    ,inifrm -- 对应的业务交易
    ,filefrm -- 影像类别
    ,filetype -- 影像类型
    ,filedesc -- 影像描述
    ,vldflg -- 有效标识
    ,fpid -- 发票影像ID
    ,invtp -- 发票类型
    ,invnb -- 发票号码
    ,invoicecode -- 发票代码
    ,untaxamt -- 未税金额
    ,invdt -- 开票日期
    ,yxflg -- 影像分类
    ,branch -- 所属机构
    ,ownref -- 业务编号
    ,delflg -- 删除标志
    ,updow -- 上传/下载
    ,isdow -- 下载成功标志
    ,usrkey -- 柜员号
    ,credat -- 创建时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    inr -- 数据序号
    ,msgid -- 报文标识号
    ,objtyp -- 关联业务表类型
    ,objinr -- 关联业务表INR
    ,fileid -- 人行回传影像ID
    ,filnam -- 影像名称
    ,filpth -- 文件存放路径
    ,inifrm -- 对应的业务交易
    ,filefrm -- 影像类别
    ,filetype -- 影像类型
    ,filedesc -- 影像描述
    ,vldflg -- 有效标识
    ,fpid -- 发票影像ID
    ,invtp -- 发票类型
    ,invnb -- 发票号码
    ,invoicecode -- 发票代码
    ,untaxamt -- 未税金额
    ,invdt -- 开票日期
    ,yxflg -- 影像分类
    ,branch -- 所属机构
    ,ownref -- 业务编号
    ,delflg -- 删除标志
    ,updow -- 上传/下载
    ,isdow -- 下载成功标志
    ,usrkey -- 柜员号
    ,credat -- 创建时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.isbs_img
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.isbs_img exchange partition p_${batch_date} with table ${iol_schema}.isbs_img_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_img to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.isbs_img_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_img',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);