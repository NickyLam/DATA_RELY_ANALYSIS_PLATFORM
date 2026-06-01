/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_dxezfxtwfh
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
alter table ${idl_schema}.orws_m_omd_dxezfxtwfh drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_dxezfxtwfh drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_dxezfxtwfh add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_dxezfxtwfh partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 数据日期
    ,jbwd  -- 经办网点
    ,lrrqjsj  -- 录入日期及时间
    ,jbgy  -- 经办柜员
    ,sqgy  -- 授权柜员
    ,zfjyxh  -- 支付交易序号
    ,jyls  -- 交易流水
    ,ywzt  -- 业务状态
    ,sjfkrzh  -- 实际付款人账号
    ,sjfkrmc  -- 实际付款人名称
    ,jyje  -- 交易金额
    ,jbwdmc  -- 机构名称
    ,zfxt  -- 支付系统
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(date_id,chr(13),''),chr(10),'')  -- 数据日期
    ,replace(replace(rtrim(jbwd),chr(13),''),chr(10),'')  -- 经办网点
    ,replace(replace(rtrim(lrrqjsj),chr(13),''),chr(10),'')  -- 录入日期及时间
    ,replace(replace(rtrim(jbgy),chr(13),''),chr(10),'')  -- 经办柜员
    ,replace(replace(rtrim(sqgy),chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(rtrim(zfjyxh),chr(13),''),chr(10),'')  -- 支付交易序号
    ,replace(replace(rtrim(jyls),chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(rtrim(ywzt),chr(13),''),chr(10),'')  -- 业务状态
    ,replace(replace(rtrim(sjfkrzh),chr(13),''),chr(10),'')  -- 实际付款人账号
    ,replace(replace(rtrim(sjfkrmc),chr(13),''),chr(10),'')  -- 实际付款人名称
    ,jyje  -- 交易金额
    ,replace(replace(rtrim(jbwdmc),chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(rtrim(zfxt),chr(13),''),chr(10),'')  -- 支付系统
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_dxezfxtwfh
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_dxezfxtwfh',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);