/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_lm_client_tran_limit_ret1
CreateDate: 20250208
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ncbs_rb_lm_client_tran_limit_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('ncbs_rb_lm_client_tran_limit');

  if v_var <> 0 then
    execute immediate 'alter table ncbs_rb_lm_client_tran_limit drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table ncbs_rb_lm_client_tran_limit add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.ncbs_rb_lm_client_tran_limit (
    base_acct_no -- 交易账号/卡号
    ,acct_ccy -- 账户币种
    ,acct_seq_no -- 账户子账号
    ,prod_type -- 产品编号
    ,client_no -- 客户编号
    ,limit_ref -- 限额编码
    ,limit_max_amt -- 最大限额
    ,limit_min_amt -- 限额最小金额
    ,limit_max_num -- 限额最大笔数
    ,tran_timestamp -- 交易时间戳
    ,company -- 法人
    ,seq_no -- 序号
    ,limit_main_type -- 限额大类
    ,limit_reason -- 限额设置原因|限额设置原因
    ,tran_limit_due_date -- 交易限额有效期
    ,start_dt -- 开始时间
    ,end_dt -- 结束时间
    ,id_mark -- 增删标志
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no as base_acct_no -- 交易账号/卡号
    ,acct_ccy as acct_ccy -- 账户币种
    ,acct_seq_no as acct_seq_no -- 账户子账号
    ,prod_type as prod_type -- 产品编号
    ,client_no as client_no -- 客户编号
    ,limit_ref as limit_ref -- 限额编码
    ,limit_max_amt as limit_max_amt -- 最大限额
    ,limit_min_amt as limit_min_amt -- 限额最小金额
    ,limit_max_num as limit_max_num -- 限额最大笔数
    ,tran_timestamp as tran_timestamp -- 交易时间戳
    ,company as company -- 法人
    ,seq_no as seq_no -- 序号
    ,limit_main_type as limit_main_type -- 限额大类
    ,' ' as limit_reason -- 限额设置原因|限额设置原因
    ,to_date('00010101','yyyymmdd') as tran_limit_due_date -- 交易限额有效期
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_lm_client_tran_limit_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

