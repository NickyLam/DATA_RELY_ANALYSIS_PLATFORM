/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_card_change_rgst_b_ncbsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_card_change_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_card_change_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_card_change_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_card_change_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
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
    ,aldy_proc_flg -- 已处理标志
    ,charge_tran_ref_no -- 收费交易参考号
    ,exper_odd_no -- 快递单号
    ,appl_id -- 申请编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_card_change_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cd_card_chg-1
insert into ${iml_schema}.evt_card_change_rgst_b_ncbsi1_tm(
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
    ,aldy_proc_flg -- 已处理标志
    ,charge_tran_ref_no -- 收费交易参考号
    ,exper_odd_no -- 快递单号
    ,appl_id -- 申请编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101016'||P1.OLD_CARD_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.APPLY_DATE -- 申请日期
    ,P1.OLD_CARD_NO -- 原卡号
    ,P1.TRAN_DATE -- 交易日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,nvl(trim(P1.CARD_CHANGE_REASON),'-') -- 更换原因代码
    ,P1.CHANGE_STATUS -- 变更类型状态代码
    ,P1.PROMISSORY_DATE -- 约定领卡日期
    ,P1.PROD_TYPE -- 卡产品编号
    ,P1.NEW_CARD_NO -- 新卡号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.GAIN_TYPE),'-') -- 领取方式代码
    ,DECODE(TRIM(P1.SAME_NO_FLAG),'','-','Y','1','N','0',P1.SAME_NO_FLAG) -- 同号换卡标志
    ,DECODE(TRIM(P1.URGENT_FLAG),'','-','Y','1','N','0',P1.URGENT_FLAG) -- 加急标志
    ,P1.LOST_NO -- 挂失编号
    ,P1.ADDRESS -- 客户地址
    ,P1.POSTAL_CODE -- 邮政编码
    ,P1.REMARK -- 备注
    ,P1.CONTACT_TEL -- 电话号码
    ,P1.USER_ID -- 交易柜员编号
    ,P1.APPLY_USER_ID -- 申请柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,nvl(trim(P1.DEAL_STATUS),'-') -- 已处理标志
    ,P1.FEE_REFERENCE -- 收费交易参考号
    ,P1.PACKAGE_NO -- 快递单号
    ,P1.APPLY_NO -- 申请编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cd_card_chg' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cd_card_chg p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.base_acct_no = p8.base_acct_no
   and p8.base_acct_no like '0%'
where  1 = 1 
    and P1.tran_date=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_card_change_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_card_change_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_card_change_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_card_change_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_card_change_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_card_change_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);