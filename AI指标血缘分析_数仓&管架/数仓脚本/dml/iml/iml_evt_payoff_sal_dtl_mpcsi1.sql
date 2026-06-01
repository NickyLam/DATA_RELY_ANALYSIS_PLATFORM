/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_payoff_sal_dtl_mpcsi1
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
drop table ${iml_schema}.evt_payoff_sal_dtl_mpcsi1_tm purge;
alter table ${iml_schema}.evt_payoff_sal_dtl add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_payoff_sal_dtl modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_payoff_sal_dtl_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,batch_flow_num -- 批次流水号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_amt -- 交易金额
    ,acct_resp_code -- 账户响应码
    ,acct_num_err_info -- 账号错误信息
    ,host_tran_flow_num -- 主机交易流水号
    ,host_tran_dt -- 主机交易日期
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_payoff_sal_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a60projdf_sign_detail-1
insert into ${iml_schema}.evt_payoff_sal_dtl_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,batch_flow_num -- 批次流水号
    ,seq_num -- 序号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,tran_amt -- 交易金额
    ,acct_resp_code -- 账户响应码
    ,acct_num_err_info -- 账号错误信息
    ,host_tran_flow_num -- 主机交易流水号
    ,host_tran_dt -- 主机交易日期
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104048'||P1.TRANSQ||P1.TRANDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRANSQ -- 交易流水号
    ,${iml_schema}.timeformat_min(P1.TRANDT) -- 交易日期
    ,P1.SUMMSQ -- 批次流水号
    ,P1.CNTIDX -- 序号
    ,P1.ACCTNO -- 账户编号
    ,P1.ACCTNA -- 账户名称
    ,P1.PYTRAM -- 交易金额
    ,P1.ACCPCD -- 账户响应码
    ,P1.ACCMSG -- 账号错误信息
    ,P1.HOSTSQ -- 主机交易流水号
    ,${iml_schema}.timeformat_min(P1.HOSTDT) -- 主机交易日期
    ,P1.RESPCD -- 响应码
    ,P1.RSPMSG -- 响应信息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a60projdf_sign_detail' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a60projdf_sign_detail p1
where  1 = 1 
     and p1.trandt='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_payoff_sal_dtl truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_payoff_sal_dtl exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_payoff_sal_dtl_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_payoff_sal_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_payoff_sal_dtl_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_payoff_sal_dtl', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);