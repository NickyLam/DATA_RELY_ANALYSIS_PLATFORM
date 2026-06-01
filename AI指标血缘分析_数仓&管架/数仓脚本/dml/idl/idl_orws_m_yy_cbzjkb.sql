/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_orws_m_yy_cbzjkb
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
alter table ${idl_schema}.orws_m_yy_cbzjkb drop partition p_${last_date};
alter table ${idl_schema}.orws_m_yy_cbzjkb drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.orws_m_yy_cbzjkb add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.orws_m_yy_cbzjkb partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- ETL处理日期
    ,date_id  -- 业务日期
    ,brchno  -- 机构号
    ,brchna  -- 机构名称
    ,nums  -- 笔数
    ,usertp  -- 柜员类型
    ,trantp  -- 业务类型
    ,cz_dt  -- 冲正日期
    ,prcscd  -- 交易码
    ,jyna  -- 交易名称
    ,cz_item  -- 冲正项目
    ,cz_amntcd  -- 冲账借贷方向
    ,cz_acctno  -- 冲正交易账号
    ,cz_acctna  -- 冲正户名
    ,cz_tranam  -- 冲正金额
    ,cz_transq  -- 冲正交易流水号
    ,cz_bz  -- 冲账备注
    ,gyh  -- 操作柜员
    ,gy_na  -- 操作员名称
    ,sqgyh  -- 授权柜员
    ,sqgy_na  -- 授权柜员名称
    ,sttsdt  -- 原交易日期
    ,st_amntcd  -- 原交易借贷方向
    ,st_acctno  -- 原交易账号
    ,st_acctna  -- 原交易户名
    ,st_tranam  -- 原交易金额
    ,st_transq  -- 原交易流水
    ,st_gyh  -- 原交易柜员号
    ,st_gyna  -- 原交易柜员名称
    ,st_sqgyh  -- 原授权柜员号
    ,st_sqgyna  -- 原授权柜员名称
    ,bz_tsdt  -- 补账日期及时间
    ,bz_amntcd  -- 补账借贷方向
    ,bz_acctno  -- 补账交易账号
    ,bz_acctna  -- 补账户名
    ,bz_tranam  -- 金额
    ,bz_transq  -- 补账交易流水号
    ,bz_gyh  -- 补账交易柜员号
    ,bz_gyna  -- 补账交易柜员名称
    ,bz_sqgyh  -- 补账授权柜员号
    ,bz_sqgyna  -- 补账授权柜员名称
    ,bz_bz  -- 补账备注
    ,jy_qd  -- 交易渠道
    ,gz_clqk  -- 跟踪处理情况
    ,bz  -- 备注：1冲账 2 补账
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd')  -- ETL处理日期
    ,replace(replace(rtrim(date_id),chr(13),''),chr(10),'')  -- 业务日期
    ,replace(replace(rtrim(brchno),chr(13),''),chr(10),'')  -- 机构号
    ,replace(replace(rtrim(brchna),chr(13),''),chr(10),'')  -- 机构名称
    ,nums  -- 笔数
    ,replace(replace(rtrim(usertp),chr(13),''),chr(10),'')  -- 柜员类型
    ,replace(replace(rtrim(trantp),chr(13),''),chr(10),'')  -- 业务类型
    ,replace(replace(rtrim(cz_dt),chr(13),''),chr(10),'')  -- 冲正日期
    ,replace(replace(rtrim(prcscd),chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(rtrim(jyna),chr(13),''),chr(10),'')  -- 交易名称
    ,replace(replace(rtrim(cz_item),chr(13),''),chr(10),'')  -- 冲正项目
    ,replace(replace(rtrim(cz_amntcd),chr(13),''),chr(10),'')  -- 冲账借贷方向
    ,replace(replace(rtrim(cz_acctno),chr(13),''),chr(10),'')  -- 冲正交易账号
    ,replace(replace(rtrim(cz_acctna),chr(13),''),chr(10),'')  -- 冲正户名
    ,cz_tranam  -- 冲正金额
    ,replace(replace(rtrim(cz_transq),chr(13),''),chr(10),'')  -- 冲正交易流水号
    ,replace(replace(rtrim(cz_bz),chr(13),''),chr(10),'')  -- 冲账备注
    ,replace(replace(rtrim(gyh),chr(13),''),chr(10),'')  -- 操作柜员
    ,replace(replace(rtrim(gy_na),chr(13),''),chr(10),'')  -- 操作员名称
    ,replace(replace(rtrim(sqgyh),chr(13),''),chr(10),'')  -- 授权柜员
    ,replace(replace(rtrim(sqgy_na),chr(13),''),chr(10),'')  -- 授权柜员名称
    ,replace(replace(rtrim(sttsdt),chr(13),''),chr(10),'')  -- 原交易日期
    ,replace(replace(rtrim(st_amntcd),chr(13),''),chr(10),'')  -- 原交易借贷方向
    ,replace(replace(rtrim(st_acctno),chr(13),''),chr(10),'')  -- 原交易账号
    ,replace(replace(rtrim(st_acctna),chr(13),''),chr(10),'')  -- 原交易户名
    ,st_tranam  -- 原交易金额
    ,replace(replace(rtrim(st_transq),chr(13),''),chr(10),'')  -- 原交易流水
    ,replace(replace(rtrim(st_gyh),chr(13),''),chr(10),'')  -- 原交易柜员号
    ,replace(replace(rtrim(st_gyna),chr(13),''),chr(10),'')  -- 原交易柜员名称
    ,replace(replace(rtrim(st_sqgyh),chr(13),''),chr(10),'')  -- 原授权柜员号
    ,replace(replace(rtrim(st_sqgyna),chr(13),''),chr(10),'')  -- 原授权柜员名称
    ,replace(replace(rtrim(bz_tsdt),chr(13),''),chr(10),'')  -- 补账日期及时间
    ,replace(replace(rtrim(bz_amntcd),chr(13),''),chr(10),'')  -- 补账借贷方向
    ,replace(replace(rtrim(bz_acctno),chr(13),''),chr(10),'')  -- 补账交易账号
    ,replace(replace(rtrim(bz_acctna),chr(13),''),chr(10),'')  -- 补账户名
    ,bz_tranam  -- 金额
    ,replace(replace(rtrim(bz_transq),chr(13),''),chr(10),'')  -- 补账交易流水号
    ,replace(replace(rtrim(bz_gyh),chr(13),''),chr(10),'')  -- 补账交易柜员号
    ,replace(replace(rtrim(bz_gyna),chr(13),''),chr(10),'')  -- 补账交易柜员名称
    ,replace(replace(rtrim(bz_sqgyh),chr(13),''),chr(10),'')  -- 补账授权柜员号
    ,replace(replace(rtrim(bz_sqgyna),chr(13),''),chr(10),'')  -- 补账授权柜员名称
    ,replace(replace(rtrim(bz_bz),chr(13),''),chr(10),'')  -- 补账备注
    ,replace(replace(rtrim(jy_qd),chr(13),''),chr(10),'')  -- 交易渠道
    ,replace(replace(rtrim(gz_clqk),chr(13),''),chr(10),'')  -- 跟踪处理情况
    ,replace(replace(rtrim(bz),chr(13),''),chr(10),'')  -- 备注：1冲账 2 补账
    ,replace(replace(rtrim(''),chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- ETL处理时间戳
 from ${iol_schema}.odss_m_yy_cbzjkb
where etl_dt=to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'orws_m_yy_cbzjkb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);