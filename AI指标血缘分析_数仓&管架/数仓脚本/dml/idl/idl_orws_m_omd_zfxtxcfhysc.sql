/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_omd_zfxtxcfhysc
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
alter table ${idl_schema}.orws_m_omd_zfxtxcfhysc drop partition p_${last_date};
alter table ${idl_schema}.orws_m_omd_zfxtxcfhysc drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_omd_zfxtxcfhysc add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_omd_zfxtxcfhysc partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 数据日期
    ,xh  -- 序号
    ,zfjyxh  -- 支付交易序号
    ,ywzl  -- 业务种类
    ,jyrq  -- 交易日期
    ,jysj  -- 交易时间
    ,jygy  -- 交易柜员
    ,jygymc  -- 交易柜员名称
    ,sqgy  -- 授权柜员
    ,sqgymc  -- 授权柜员名称
    ,jywd  -- 交易网点
    ,jywdmc  -- 交易网点名称
    ,jyls  -- 交易流水
    ,fkrzhmc  -- 付款人账户名称
    ,fkrzh  -- 付款人账号
    ,khwd  -- 开户网点
    ,khwdmc  -- 开户网点名称
    ,skrzhmc  -- 收款人账户名称
    ,skrzh  -- 收款人账号
    ,je  -- 金额
    ,jyzt  -- 交易状态
    ,zfxt  -- 支付系统
    ,ywlx  -- 业务类型
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(rtrim(date_id),chr(13),''),chr(10),'')  -- 数据日期
    ,xh  -- 序号
    ,replace(replace(rtrim(zfjyxh),chr(13),''),chr(10),'')  -- 支付交易序号
    ,replace(replace(rtrim(ywzl),chr(13),''),chr(10),'')  -- 业务种类
    ,replace(replace(rtrim(jyrq),chr(13),''),chr(10),'')  -- 交易日期
    ,replace(replace(rtrim(jysj),chr(13),''),chr(10),'')  -- 交易时间
    ,replace(replace(rtrim(jygy),chr(13),''),chr(10),'')  -- 交易柜员
    ,replace(replace(rtrim(jygymc),chr(13),''),chr(10),'')  -- 交易柜员名称
    ,replace(replace(rtrim(sqgy),chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(rtrim(sqgymc),chr(13),''),chr(10),'')  -- 授权柜员名称
    ,replace(replace(rtrim(jywd),chr(13),''),chr(10),'')  -- 交易网点
    ,replace(replace(rtrim(jywdmc),chr(13),''),chr(10),'')  -- 交易网点名称
    ,replace(replace(rtrim(jyls),chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(rtrim(fkrzhmc),chr(13),''),chr(10),'')  -- 付款人账户名称
    ,replace(replace(rtrim(fkrzh),chr(13),''),chr(10),'')  -- 付款人账号
    ,replace(replace(rtrim(khwd),chr(13),''),chr(10),'')  -- 开户网点
    ,replace(replace(rtrim(khwdmc),chr(13),''),chr(10),'')  -- 开户网点名称
    ,replace(replace(rtrim(skrzhmc),chr(13),''),chr(10),'')  -- 收款人账户名称
    ,replace(replace(rtrim(skrzh),chr(13),''),chr(10),'')  -- 收款人账号
    ,je  -- 金额
    ,replace(replace(rtrim(jyzt),chr(13),''),chr(10),'')  -- 交易状态
    ,replace(replace(rtrim(zfxt),chr(13),''),chr(10),'')  -- 支付系统
    ,replace(replace(rtrim(ywlx),chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_omd_zfxtxcfhysc
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_omd_zfxtxcfhysc',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);