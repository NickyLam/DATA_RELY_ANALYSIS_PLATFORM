/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_yhhpyc
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.orws_m_omd_yhhpyc drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_yhhpyc drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_yhhpyc add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_yhhpyc partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 数据日期
    ,gs_no  -- 序号
    ,cshpbillnb  -- 汇票号码
    ,cshpbilltype  -- 汇票类型
    ,hpstatus  -- 记账状态
    ,billst  -- 汇票状态
    ,cshpbillamt  -- 出票金额
    ,paybrnno  -- 签发行行号 
    ,cshpbilldate  -- 签发日期
    ,payacct  -- 申请人账号
    ,payname  -- 申请人名称
    ,tranus  -- 交易柜员
    ,ckbkus  -- 复核柜员
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 数据日期
    ,gs_no  -- 序号
    ,replace(replace(rtrim(cshpbillnb),chr(13),''),chr(10),'')  -- 汇票号码
    ,replace(replace(rtrim(cshpbilltype),chr(13),''),chr(10),'')  -- 汇票类型
    ,replace(replace(rtrim(hpstatus),chr(13),''),chr(10),'')  -- 记账状态
    ,replace(replace(rtrim(billst),chr(13),''),chr(10),'')  -- 汇票状态
    ,cshpbillamt  -- 出票金额
    ,replace(replace(rtrim(paybrnno),chr(13),''),chr(10),'')  -- 签发行行号 
    ,replace(replace(rtrim(cshpbilldate),chr(13),''),chr(10),'')  -- 签发日期
    ,replace(replace(rtrim(payacct),chr(13),''),chr(10),'')  -- 申请人账号
    ,replace(replace(rtrim(payname),chr(13),''),chr(10),'')  -- 申请人名称
    ,replace(replace(rtrim(tranus),chr(13),''),chr(10),'')  -- 交易柜员
    ,replace(replace(rtrim(ckbkus),chr(13),''),chr(10),'')  -- 复核柜员
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_yhhpyc
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_yhhpyc',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);