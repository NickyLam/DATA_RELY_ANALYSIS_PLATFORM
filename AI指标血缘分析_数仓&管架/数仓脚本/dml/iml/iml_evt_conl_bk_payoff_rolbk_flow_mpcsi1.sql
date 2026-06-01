/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_conl_bk_payoff_rolbk_flow_mpcsi1
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
drop table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow_mpcsi1_tm purge;
alter table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_type_cd -- 交易类型代码
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_tm -- 交易时间
    ,tran_rest_cd -- 交易结果代码
    ,midgrod_dt -- 中台日期
    ,midgrod_flow_num -- 中台流水号
    ,bus_flow_num -- 业务流水号
    ,tran_inside_acct_acct_num -- 过渡内部户账号
    ,tran_inside_acct_name -- 过渡内部户名称
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,cust_id -- 客户编号
    ,core_dt -- 核心日期
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_conl_bk_payoff_rolbk_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a01tbattranlist-1
insert into ${iml_schema}.evt_conl_bk_payoff_rolbk_flow_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_type_cd -- 交易类型代码
    ,tran_amt -- 交易金额
    ,curr_cd -- 币种代码
    ,tran_tm -- 交易时间
    ,tran_rest_cd -- 交易结果代码
    ,midgrod_dt -- 中台日期
    ,midgrod_flow_num -- 中台流水号
    ,bus_flow_num -- 业务流水号
    ,tran_inside_acct_acct_num -- 过渡内部户账号
    ,tran_inside_acct_name -- 过渡内部户名称
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,cust_id -- 客户编号
    ,core_dt -- 核心日期
    ,core_flow_num -- 核心流水号
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102074'||P1.TRNSEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRNSEQNO -- 交易流水号
    ,nvl(trim(P1.TRNTYPE),'-') -- 交易类型代码
    ,to_number(nvl(trim(P1.TRNAMT),0)) -- 交易金额
    ,case when trim(P1.CCY)='01' then 'CNY' else nvl(trim(P1.CCY),'-') end -- 币种代码
    ,${iml_schema}.dateformat_max2(P1.TRNDTTS) -- 交易时间
    ,nvl(trim(P1.TRNRESULT),'-') -- 交易结果代码
    ,${iml_schema}.dateformat_max2(P1.FNTDT) -- 中台日期
    ,P1.FNTSEQNO -- 中台流水号
    ,P1.UNIQUE_SEQ_NUM -- 业务流水号
    ,P1.INNERACNO -- 过渡内部户账号
    ,P1.INNERACNA -- 过渡内部户名称
    ,P1.PAYACCTNO -- 转出账户编号
    ,P1.PAYACCTNAME -- 转出账户名称
    ,P1.RCVACCTNO -- 转入账户编号
    ,P1.RCVACCTNAME -- 转入账户名称
    ,P1.CUSTNO -- 客户编号
    ,${iml_schema}.dateformat_max2(P1.HOSTDT) -- 核心日期
    ,P1.HOSTSEQNO -- 核心流水号
    ,P1.RESERVE -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a01tbattranlist' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a01tbattranlist p1
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_conl_bk_payoff_rolbk_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_conl_bk_payoff_rolbk_flow_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_conl_bk_payoff_rolbk_flow', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);