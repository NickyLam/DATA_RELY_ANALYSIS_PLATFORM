/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_contra_reg
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
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
                       FROM ncbs_rb_tran_contra_reg_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_tran_contra_reg');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_tran_contra_reg drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_tran_contra_reg add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_rb_tran_contra_reg(
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,oth_real_base_acct_no -- 真实交易对手账号
            ,oth_real_tran_name -- 真实交易对手名称
            ,contra_bank_code -- 交易对手行号
            ,tran_amt -- 交易金额
            ,oth_real_acct_seq_no -- 真实交易对手账户序号
            ,register_seq_no -- 补录子序号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
            ,contra_bank_name -- 真实对手行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            seq_no -- 序号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,sub_seq_no -- 系统子流水号
            ,oth_real_base_acct_no -- 真实交易对手账号
            ,oth_real_tran_name -- 真实交易对手名称
            ,contra_bank_code -- 交易对手行号
            ,tran_amt -- 交易金额
            ,oth_real_acct_seq_no -- 真实交易对手账户序号
            ,register_seq_no -- 补录子序号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,source_module -- 源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
            ,' ' as contra_bank_name -- 真实对手行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_rb_tran_contra_reg_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
