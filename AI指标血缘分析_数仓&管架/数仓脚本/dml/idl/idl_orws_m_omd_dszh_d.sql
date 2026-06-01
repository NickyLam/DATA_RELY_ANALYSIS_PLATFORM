/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_dszh_d
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
alter table ${idl_schema}.orws_m_omd_dszh_d drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_dszh_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_dszh_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_dszh_d partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 会计日期
    ,branch_code  -- 机构
    ,branch_name  -- 机构名称
    ,custno  -- 客户号
    ,acctno  -- 账户
    ,acctna  -- 客户名称
    ,certtp  -- 证件类型
    ,certno  -- 证件号码
    ,tel  -- 手机
    ,opendate  -- 开户日期
    ,processor  -- 监控情况
    ,openti  -- 交易时间
    ,transq  -- 交易流水
    ,tran_user  -- 经办柜员
    ,usernam  -- 经办柜员名
    ,branch_code_ex  -- 最近开户机构
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace(branch_code,chr(13),''),chr(10),'')  -- 机构
    ,replace(replace(rtrim(branch_name),chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(custno,chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(acctno,chr(13),''),chr(10),'')  -- 账户
    ,replace(replace(rtrim(acctna),chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(rtrim(certtp),chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(rtrim(certno),chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(rtrim(tel),chr(13),''),chr(10),'')  -- 手机
    ,replace(replace(rtrim(opendate),chr(13),''),chr(10),'')  -- 开户日期
    ,replace(replace(processor,chr(13),''),chr(10),'')  -- 监控情况
    ,replace(replace(rtrim(openti),chr(13),''),chr(10),'')  -- 交易时间
    ,replace(replace(rtrim(transq),chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(rtrim(tran_user),chr(13),''),chr(10),'')  -- 经办柜员
    ,replace(replace(rtrim(usernam),chr(13),''),chr(10),'')  -- 经办柜员名
    ,replace(replace(rtrim(branch_code_ex),chr(13),''),chr(10),'')  -- 最近开户机构
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_dszh_d
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_dszh_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);