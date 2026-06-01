/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_agt_wl_acct
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
alter table ${idl_schema}.aml_agt_wl_acct drop partition p_${last_date};
alter table ${idl_schema}.aml_agt_wl_acct drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_agt_wl_acct add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_agt_wl_acct (
    etl_dt  -- 数据日期
    ,acct_id  -- 账户编号
    ,lp_id  -- 法人编号
    ,acct_name  -- 账户名称
    ,acct_type_cd  -- 账户类型代码
    ,cap_acct_id  -- 资金账户编号
    ,open_bank_name  -- 开户行名称
    ,open_bank_num  -- 开户行号
    ,open_acct_name  -- 开户名称
    ,acct_status_cd  -- 账户状态代码
    ,teller_id  -- 柜员编号
    ,asset_acct_type_cd  -- 资产账户类型代码
    ,bd_card_no  -- 绑定卡卡号
    ,bind_mobile_no  -- 绑定手机号码
    ,pbc_fin_inst_code  -- 人行金融机构编码
    ,obank_card_flg  -- 他行卡标志
    ,cust_id  -- 客户编号
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'')  -- 账户类型代码
    ,replace(replace(t1.cap_acct_id,chr(13),''),chr(10),'')  -- 资金账户编号
    ,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'')  -- 开户行名称
    ,replace(replace(t1.open_bank_num,chr(13),''),chr(10),'')  -- 开户行号
    ,replace(replace(t1.open_acct_name,chr(13),''),chr(10),'')  -- 开户名称
    ,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'')  -- 账户状态代码
    ,replace(replace(t1.teller_id,chr(13),''),chr(10),'')  -- 柜员编号
    ,replace(replace(t1.asset_acct_type_cd,chr(13),''),chr(10),'')  -- 资产账户类型代码
    ,replace(replace(t1.bd_card_no,chr(13),''),chr(10),'')  -- 绑定卡卡号
    ,replace(replace(t1.bind_mobile_no,chr(13),''),chr(10),'')  -- 绑定手机号码
    ,replace(replace(t1.pbc_fin_inst_code,chr(13),''),chr(10),'')  -- 人行金融机构编码
    ,replace(replace(t1.obank_card_flg,chr(13),''),chr(10),'')  -- 他行卡标志
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_wl_acct t1    --网贷账户
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_agt_wl_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);