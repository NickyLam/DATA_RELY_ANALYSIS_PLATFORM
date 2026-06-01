/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_gsdjb_d
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
alter table ${idl_schema}.orws_m_omd_gsdjb_d drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_gsdjb_d drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_gsdjb_d add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_gsdjb_d partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 业务日期
    ,indexno  -- 序号
    ,brchno  -- 开户机构
    ,rplssq  -- 挂失登记号
    ,rplsdt  -- 挂失日期
    ,acctno  -- 账号
    ,acctna  -- 户名
    ,rplsfs  -- 挂失方式
    ,dcmttp  -- 凭证类型
    ,dcmtno  -- 凭证号
    ,rplstp  -- 挂失种类  
    ,idtftp  -- 证件类型
    ,idtfno  -- 证件号码
    ,agcuna  -- 代理人
    ,agidtp  -- 代理证件类型
    ,agidno  -- 代理证件号码
    ,rplsus  -- 挂失柜员
    ,authus  -- 挂失授权人
    ,unlsus  -- 解挂柜员
    ,ckbkus  -- 解挂授权人
    ,unlsdt  -- 处理日期
    ,unchtg  -- 处理结果
    ,ugcuna  -- 代理人
    ,ugidtp  -- 代理证件类型
    ,ugidno  -- 代理证件号码
    ,tranbr  -- 
    ,gstranti  -- 
    ,gsrplssq  -- 
    ,gsservtp  -- 
    ,jgtranti  -- 
    ,unlssq  -- 
    ,jgservtp  -- 
    ,transq  -- 
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd')  -- 
    ,replace(replace(rtrim(date_id),chr(13),''),chr(10),'')  -- 业务日期
    ,indexno  -- 序号
    ,replace(replace(brchno,chr(13),''),chr(10),'')  -- 开户机构
    ,replace(replace(rplssq,chr(13),''),chr(10),'')  -- 挂失登记号
    ,replace(replace(rplsdt,chr(13),''),chr(10),'')  -- 挂失日期
    ,replace(replace(acctno,chr(13),''),chr(10),'')  -- 账号
    ,replace(replace(rtrim(acctna),chr(13),''),chr(10),'')  -- 户名
    ,replace(replace(rplsfs,chr(13),''),chr(10),'')  -- 挂失方式
    ,replace(replace(rtrim(dcmttp),chr(13),''),chr(10),'')  -- 凭证类型
    ,replace(replace(rtrim(dcmtno),chr(13),''),chr(10),'')  -- 凭证号
    ,replace(replace(rplstp,chr(13),''),chr(10),'')  -- 挂失种类  
    ,replace(replace(rtrim(idtftp),chr(13),''),chr(10),'')  -- 证件类型
    ,replace(replace(rtrim(idtfno),chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(rtrim(agcuna),chr(13),''),chr(10),'')  -- 代理人
    ,replace(replace(rtrim(agidtp),chr(13),''),chr(10),'')  -- 代理证件类型
    ,replace(replace(rtrim(agidno),chr(13),''),chr(10),'')  -- 代理证件号码
    ,replace(replace(rtrim(rplsus),chr(13),''),chr(10),'')  -- 挂失柜员
    ,replace(replace(rtrim(authus),chr(13),''),chr(10),'')  -- 挂失授权人
    ,replace(replace(rtrim(unlsus),chr(13),''),chr(10),'')  -- 解挂柜员
    ,replace(replace(rtrim(ckbkus),chr(13),''),chr(10),'')  -- 解挂授权人
    ,replace(replace(rtrim(unlsdt),chr(13),''),chr(10),'')  -- 处理日期
    ,replace(replace(rtrim(unchtg),chr(13),''),chr(10),'')  -- 处理结果
    ,replace(replace(rtrim(ugcuna),chr(13),''),chr(10),'')  -- 代理人
    ,replace(replace(rtrim(ugidtp),chr(13),''),chr(10),'')  -- 代理证件类型
    ,replace(replace(rtrim(ugidno),chr(13),''),chr(10),'')  -- 代理证件号码
    ,replace(replace(rtrim(tranbr),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(gstranti),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(gsrplssq),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(gsservtp),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jgtranti),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(unlssq),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(jgservtp),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(transq),chr(13),''),chr(10),'')  -- 
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 
 from ${iol_schema}.odss_m_omd_gsdjb_d
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_gsdjb_d',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);