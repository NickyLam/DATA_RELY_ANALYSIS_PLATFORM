/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_vouch_loss_dtl_rgst_b_ncbsi1
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
drop table ${iml_schema}.evt_vouch_loss_dtl_rgst_b_ncbsi1_tm purge;
alter table ${iml_schema}.evt_vouch_loss_dtl_rgst_b add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_vouch_loss_dtl_rgst_b modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_vouch_loss_dtl_rgst_b_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_vouch_loss_dtl_rgst_b
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_voucher_lost_detail-1
insert into ${iml_schema}.evt_vouch_loss_dtl_rgst_b_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,loss_idf -- 挂失标识符
    ,loss_id -- 挂失编号
    ,seq_num -- 序号
    ,cust_id -- 客户编号
    ,loss_begin_dt -- 挂失起始日期
    ,reissue_begin_dt -- 补发起始日期
    ,dep_vouch_cate_cd -- 存款凭证类别代码
    ,vouch_begin_num -- 凭证起始号码
    ,vouch_termnt_num -- 凭证终止号码
    ,new_vouch_type_cd -- 新凭证类型代码
    ,new_vouch_no -- 新凭证号码
    ,vouch_loss_status_cd -- 凭证挂失状态代码
    ,chn_id -- 渠道编号
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101046'||P1.LOST_KEY||P1.LOST_NO||P1.SEQ_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.LOST_KEY -- 挂失标识符
    ,P1.LOST_NO -- 挂失编号
    ,P1.SEQ_NO -- 序号
    ,P1.CLIENT_NO -- 客户编号
    ,${iml_schema}.dateformat_max2(P1.STOP_START_DATE) -- 挂失起始日期
    ,${iml_schema}.dateformat_max2(P1.STOP_END_DATE) -- 补发起始日期
    ,P1.DOC_TYPE -- 存款凭证类别代码
    ,P1.VOUCHER_START_NO -- 凭证起始号码
    ,P1.VOUCHER_END_NO -- 凭证终止号码
    ,P1.NEW_DOC_TYPE -- 新凭证类型代码
    ,P1.NEW_VOUCHER_NO -- 新凭证号码
    ,P1.VOUCHER_LOST_STATUS -- 凭证挂失状态代码
    ,P1.SOURCE_TYPE -- 渠道编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_voucher_lost_detail' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_voucher_lost_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_vouch_loss_dtl_rgst_b truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_vouch_loss_dtl_rgst_b exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_vouch_loss_dtl_rgst_b_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_vouch_loss_dtl_rgst_b to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_vouch_loss_dtl_rgst_b_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_vouch_loss_dtl_rgst_b', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);