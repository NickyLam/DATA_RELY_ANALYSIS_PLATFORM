/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_cdgh_d
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
alter table ${idl_schema}.orws_m_omd_cdgh_d drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_cdgh_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_cdgh_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_cdgh_d partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,ods_src_dt  -- 会计日期
    ,trandt  -- 交易日期
    ,branch_name  -- 上级机构
    ,tranbr  -- 交易机构编码
    ,brchna  -- 交易机构名称
    ,acctno  -- 帐号
    ,acctna  -- 账户名称
    ,accttp  -- 账户性质
    ,bus_type  -- 业务类型
    ,trantime  -- 交易时间
    ,transq  -- 交易流水
    ,tranus  -- 交易柜员号
    ,userna  -- 交易柜员名
    ,tranam  -- 交易金额
    ,processor  -- 异常原因
    ,authnam  -- 授权柜员名称
    ,authus  -- 授权柜员号
    ,dcmttp  -- 凭证类型
    ,menuid  -- 交易码
    ,menunam  -- 交易名称
    ,acct_branchno  -- 开户机构号
    ,acct_branchnam  -- 开户机构名称
    ,dcmtno  -- 凭证号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(ods_src_dt,chr(13),''),chr(10),'')  -- 会计日期
    ,replace(replace(trandt,chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(rtrim(branch_name),chr(13),''),chr(10),'')  -- 上级机构
    ,replace(replace(rtrim(tranbr),chr(13),''),chr(10),'')  -- 交易机构编码
    ,replace(replace(rtrim(brchna),chr(13),''),chr(10),'')  -- 交易机构名称
    ,replace(replace(rtrim(acctno),chr(13),''),chr(10),'')  -- 帐号
    ,replace(replace(rtrim(acctna),chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(rtrim(accttp),chr(13),''),chr(10),'')  -- 账户性质
    ,replace(replace(rtrim(bus_type),chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(rtrim(trantime),chr(13),''),chr(10),'')  -- 交易时间
    ,replace(replace(transq,chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(rtrim(tranus),chr(13),''),chr(10),'')  -- 交易柜员号
    ,replace(replace(rtrim(userna),chr(13),''),chr(10),'')  -- 交易柜员名
    ,tranam  -- 交易金额
    ,replace(replace(rtrim(processor),chr(13),''),chr(10),'')  -- 异常原因
    ,replace(replace(rtrim(authnam),chr(13),''),chr(10),'')  -- 授权柜员名称
    ,replace(replace(rtrim(authus),chr(13),''),chr(10),'')  -- 授权柜员号
    ,replace(replace(rtrim(dcmttp),chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(rtrim(menuid),chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(rtrim(menunam),chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(rtrim(acct_branchno),chr(13),''),chr(10),'')  -- 开户机构号
    ,replace(replace(rtrim(acct_branchnam),chr(13),''),chr(10),'')  -- 开户机构名称
    ,replace(replace(rtrim(dcmtno),chr(13),''),chr(10),'')  -- 凭证号
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_cdgh_d
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_cdgh_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);