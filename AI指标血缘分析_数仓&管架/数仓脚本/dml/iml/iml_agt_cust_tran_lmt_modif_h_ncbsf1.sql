/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cust_tran_lmt_modif_h_ncbsf1
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
drop table ${iml_schema}.agt_cust_tran_lmt_modif_h_ncbsf1_tm purge;
alter table ${iml_schema}.agt_cust_tran_lmt_modif_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_cust_tran_lmt_modif_h modify partition p_ncbsf1
    add subpartition p_ncbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cust_tran_lmt_modif_h_ncbsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,acct_id -- 账户编号
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,chn_id -- 渠道编号
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,single_day_lmt -- 单日限额
    ,init_single_day_lmt -- 原单日限额
    ,single_day_lmt_cnt -- 单日限制笔数
    ,init_single_day_lmt_cnt -- 原单日限制笔数
    ,sig_lmt -- 单笔限额
    ,init_sig_lmt -- 原单笔限额
    ,year_lmt -- 年度限额
    ,init_year_lmt -- 原年度限额
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,tran_teller_id -- 交易柜员编号
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cust_tran_lmt_modif_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_rb_lm_client_limit_record-1
insert into ${iml_schema}.agt_cust_tran_lmt_modif_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_acct_num -- 客户账号
    ,acct_id -- 账户编号
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,chn_id -- 渠道编号
    ,lmt_cate_cd -- 限额类别代码
    ,lmt_set_rs_cd -- 限额设置原因代码
    ,single_day_lmt -- 单日限额
    ,init_single_day_lmt -- 原单日限额
    ,single_day_lmt_cnt -- 单日限制笔数
    ,init_single_day_lmt_cnt -- 原单日限制笔数
    ,sig_lmt -- 单笔限额
    ,init_sig_lmt -- 原单笔限额
    ,year_lmt -- 年度限额
    ,init_year_lmt -- 原年度限额
    ,tran_lmt_valid_dt -- 交易限额有效日期
    ,tran_teller_id -- 交易柜员编号
    ,tran_ref_no -- 交易参考号
    ,tran_dt -- 交易日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300031'||P1.CLIENT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,to_char(P1.INTERNAL_KEY) -- 账户编号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.PROD_TYPE -- 产品编号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.SOURCE_TYPE -- 渠道编号
    ,nvl(trim(P1.LIMIT_MAIN_TYPE),'-') -- 限额类别代码
    ,nvl(trim(P1.LIMIT_REASON),'8') -- 限额设置原因代码
    ,P1.DAY_LIMIT_MAX_AMT -- 单日限额
    ,P1.OLD_DAY_LIMIT_AMT -- 原单日限额
    ,P1.DAY_LIMIT_MAX_NUM -- 单日限制笔数
    ,P1.OLD_DAY_LIMIT_NUM -- 原单日限制笔数
    ,P1.SINGLE_LIMIT_MAX_AMT -- 单笔限额
    ,P1.OLD_SINGLE_LIMIT_AMT -- 原单笔限额
    ,P1.YEAR_LIMIT_MAX_AMT -- 年度限额
    ,P1.OLD_YEAR_LIMIT_AMT -- 原年度限额
    ,P1.TRAN_LIMIT_DUE_DATE -- 交易限额有效日期
    ,P1.USER_ID -- 交易柜员编号
    ,P1.REFERENCE -- 交易参考号
    ,iml.timeformat_max2(P1.TRAN_TIMESTAMP) -- 交易日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_lm_client_limit_record' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_lm_client_limit_record p1
where  1 = 1 
     and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.agt_cust_tran_lmt_modif_h truncate subpartition p_ncbsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.agt_cust_tran_lmt_modif_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cust_tran_lmt_modif_h_ncbsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cust_tran_lmt_modif_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_cust_tran_lmt_modif_h_ncbsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cust_tran_lmt_modif_h', partname => 'p_ncbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);