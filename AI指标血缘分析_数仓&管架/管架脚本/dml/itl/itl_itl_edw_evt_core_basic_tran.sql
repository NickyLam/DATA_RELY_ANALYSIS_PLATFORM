/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_core_basic_tran
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
alter table ${itl_schema}.itl_edw_evt_core_basic_tran drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_core_basic_tran drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_core_basic_tran add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_core_basic_tran partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,lp_id  -- 法人编号
    ,tran_dt  -- 交易日期
    ,tran_flow_num  -- 交易流水号
    ,tran_tm  -- 交易时间
    ,tran_kind_cd  -- 交易种类代码
    ,tran_code  -- 交易码
    ,tran_chn_id  -- 交易渠道编号
    ,tran_org_id  -- 交易机构编号
    ,termn_id  -- 终端编号
    ,tran_teller_id  -- 交易柜员编号
    ,check_teller_id  -- 复核柜员编号
    ,auth_teller_id  -- 授权柜员编号
    ,bal_chk_flg  -- 勾对标志
    ,tran_status_cd  -- 交易状态代码
    ,ova_flow_num  -- 全局流水号
    ,ext_flow_num  -- 外部流水号
    ,cnter_tran_code  -- 柜面交易码
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,t1.tran_tm  -- 交易时间
    ,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'')  -- 交易种类代码
    ,replace(replace(t1.tran_code,chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(t1.tran_chn_id,chr(13),''),chr(10),'')  -- 交易渠道编号
    ,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'')  -- 交易机构编号
    ,replace(replace(t1.termn_id,chr(13),''),chr(10),'')  -- 终端编号
    ,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'')  -- 交易柜员编号
    ,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'')  -- 复核柜员编号
    ,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'')  -- 授权柜员编号
    ,replace(replace(t1.bal_chk_flg,chr(13),''),chr(10),'')  -- 勾对标志
    ,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'')  -- 交易状态代码
    ,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'')  -- 全局流水号
    ,replace(replace(t1.ext_flow_num,chr(13),''),chr(10),'')  -- 外部流水号
    ,replace(replace(t1.cnter_tran_code,chr(13),''),chr(10),'')  -- 柜面交易码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from iml.v_evt_core_basic_tran t1    --核心基本交易
where 1=1 ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_core_basic_tran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);