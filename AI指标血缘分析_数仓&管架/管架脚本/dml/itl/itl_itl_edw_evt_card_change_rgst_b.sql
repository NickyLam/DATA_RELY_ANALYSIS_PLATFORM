/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_card_change_rgst_b
CreateDate: 20220413
Logs:
    郑沛隆 2022-04-13 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_evt_card_change_rgst_b drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_card_change_rgst_b drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_card_change_rgst_b add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_card_change_rgst_b partition for (to_date('${batch_date}','yyyymmdd')) (
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_dt -- 申请日期
    ,init_card_no -- 原卡号
    ,tran_dt -- 交易日期
    ,tran_org_id -- 交易机构编号
    ,change_rs_cd -- 更换原因代码
    ,modif_type_status_cd -- 变更类型状态代码
    ,apot_draw_card_dt -- 约定领卡日期
    ,card_prod_id -- 卡产品编号
    ,new_card_num -- 新卡号
    ,cust_id -- 客户编号
    ,draw_way_cd -- 领取方式代码
    ,save_num_change_card_flg -- 同号换卡标志
    ,urgent_flg -- 加急标志
    ,loss_id -- 挂失编号
    ,cust_addr -- 客户地址
    ,zip_code -- 邮政编码
    ,remark -- 备注
    ,tel_num -- 电话号码
    ,tran_teller_id -- 交易柜员编号
    ,appl_teller_id -- 申请柜员编号
    ,tran_tm -- 交易时间
    ,cust_acct_num -- 客户账号
    --,src_table_name -- 源表名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(evt_id), ' ') as evt_id -- 事件编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(appl_dt, to_date('00010101', 'yyyymmdd')) as appl_dt -- 申请日期
    ,nvl(trim(init_card_no), ' ') as init_card_no -- 原卡号
    ,nvl(tran_dt, to_date('00010101', 'yyyymmdd')) as tran_dt -- 交易日期
    ,nvl(trim(tran_org_id), ' ') as tran_org_id -- 交易机构编号
    ,nvl(trim(change_rs_cd), ' ') as change_rs_cd -- 更换原因代码
    ,nvl(trim(modif_type_status_cd), ' ') as modif_type_status_cd -- 变更类型状态代码
    ,nvl(apot_draw_card_dt, to_date('00010101', 'yyyymmdd')) as apot_draw_card_dt -- 约定领卡日期
    ,nvl(trim(card_prod_id), ' ') as card_prod_id -- 卡产品编号
    ,nvl(trim(new_card_num), ' ') as new_card_num -- 新卡号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(draw_way_cd), ' ') as draw_way_cd -- 领取方式代码
    ,nvl(trim(save_num_change_card_flg), ' ') as save_num_change_card_flg -- 同号换卡标志
    ,nvl(trim(urgent_flg), ' ') as urgent_flg -- 加急标志
    ,nvl(trim(loss_id), ' ') as loss_id -- 挂失编号
    ,nvl(trim(cust_addr), ' ') as cust_addr -- 客户地址
    ,nvl(trim(zip_code), ' ') as zip_code -- 邮政编码
    ,nvl(trim(remark), ' ') as remark -- 备注
    ,nvl(trim(tel_num), ' ') as tel_num -- 电话号码
    ,nvl(trim(tran_teller_id), ' ') as tran_teller_id -- 交易柜员编号
    ,nvl(trim(appl_teller_id), ' ') as appl_teller_id -- 申请柜员编号
    ,nvl(tran_tm, to_timestamp('00010101', 'yyyymmdd')) as tran_tm -- 交易时间
    ,nvl(trim(cust_acct_num), ' ') as cust_acct_num -- 客户账号
    --,nvl(trim(src_table_name), ' ') as src_table_name -- 源表名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_evt_card_change_rgst_b
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_evt_card_change_rgst_b to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_card_change_rgst_b',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);