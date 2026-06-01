/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_wfd_tran_71
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
alter table ${idl_schema}.orws_m_wfd_tran_71 drop partition p_${last_date};
alter table ${idl_schema}.orws_m_wfd_tran_71 drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_wfd_tran_71 add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_wfd_tran_71 partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 业务日期
    ,brchno  -- 交易机构
    ,frozdt  -- 交易日期
    ,acctno  -- 账号
    ,acctna  -- 户名
    ,subsac  -- 子户号
    ,refram  -- 申请金额
    ,cufram  -- 交易金额
    ,matudt  -- 截至日期
    ,frsptp  -- 冻结止付类型
    ,userid  -- 交易柜员 
    ,sqgy_id  -- 授权柜员
    ,exorgn  -- 执行机关
    ,idtftp_na  -- 证明类型
    ,idtfno  -- 证明书号
    ,exusna1  -- 执行人1
    ,exusna2  -- 执行人2
    ,exidtp  -- 证件一
    ,exidno  -- 号码一
    ,eidtp2  -- 证件二
    ,eidno2  -- 号码二
    ,frozsq  -- 冻结/止付流水号
    ,status  -- 状态
    ,remktx  -- 冻结/止付原因
    ,jysj  -- 
    ,jyls  -- 
    ,jqrq  -- 
    ,jqsj  -- 
    ,jqls  -- 
    ,jqgy  -- 
    ,jqsqgy  -- 
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 业务日期
    ,replace(replace(rtrim(brchno),chr(13),''),chr(10),'')  -- 交易机构
    ,replace(replace(rtrim(frozdt),chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(rtrim(acctno),chr(13),''),chr(10),'')  -- 账号
    ,replace(replace(rtrim(acctna),chr(13),''),chr(10),'')  -- 户名
    ,replace(replace(rtrim(subsac),chr(13),''),chr(10),'')  -- 子户号
    ,refram  -- 申请金额
    ,cufram  -- 交易金额
    ,replace(replace(rtrim(matudt),chr(13),''),chr(10),'')  -- 截至日期
    ,replace(replace(rtrim(frsptp),chr(13),''),chr(10),'')  -- 冻结止付类型
    ,replace(replace(rtrim(userid),chr(13),''),chr(10),'')  -- 交易柜员 
    ,replace(replace(rtrim(sqgy_id),chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(rtrim(exorgn),chr(13),''),chr(10),'')  -- 执行机关
    ,replace(replace(rtrim(idtftp_na),chr(13),''),chr(10),'')  -- 证明类型
    ,replace(replace(rtrim(idtfno),chr(13),''),chr(10),'')  -- 证明书号
    ,replace(replace(rtrim(exusna1),chr(13),''),chr(10),'')  -- 执行人1
    ,replace(replace(rtrim(exusna2),chr(13),''),chr(10),'')  -- 执行人2
    ,replace(replace(rtrim(exidtp),chr(13),''),chr(10),'')  -- 证件一
    ,replace(replace(rtrim(exidno),chr(13),''),chr(10),'')  -- 号码一
    ,replace(replace(rtrim(eidtp2),chr(13),''),chr(10),'')  -- 证件二
    ,replace(replace(rtrim(eidno2),chr(13),''),chr(10),'')  -- 号码二
    ,replace(replace(rtrim(frozsq),chr(13),''),chr(10),'')  -- 冻结/止付流水号
    ,replace(replace(rtrim(status),chr(13),''),chr(10),'')  -- 状态
    ,replace(replace(rtrim(remktx),chr(13),''),chr(10),'')  -- 冻结/止付原因
    ,replace(replace(rtrim(jysj),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jyls),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jqrq),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jqsj),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jqls),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jqgy),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jqsqgy),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_wfd_tran_71
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_wfd_tran_71',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);