/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_col_tran_recvbl_info_mimsf1
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
drop table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_col_tran_recvbl_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_col_tran_recvbl_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_col_tran_recvbl_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,lc_num -- 信用证号码
    ,fac_val_amt -- 票面金额
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_exp_dt -- 发票到期日期
    ,aging -- 账龄
    ,payer_name -- 付款人名称
    ,bkrpt_clear_flg -- 破产清算标志
    ,payer_acct_id -- 付款人账户编号
    ,advise_acct_recvbl_flg -- 通知应收账款义务人标志
    ,cred_rht_prod_flg -- 债权产生标志
    ,other_comnt -- 其他说明
    ,rela_flg -- 关系标志
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_tran_recvbl_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_col_tran_recvbl_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_receivables-
insert into ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,lc_num -- 信用证号码
    ,fac_val_amt -- 票面金额
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_exp_dt -- 发票到期日期
    ,aging -- 账龄
    ,payer_name -- 付款人名称
    ,bkrpt_clear_flg -- 破产清算标志
    ,payer_acct_id -- 付款人账户编号
    ,advise_acct_recvbl_flg -- 通知应收账款义务人标志
    ,cred_rht_prod_flg -- 债权产生标志
    ,other_comnt -- 其他说明
    ,rela_flg -- 关系标志
    ,curr_cd -- 币种代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.CREDITNO -- 信用证号码
    ,P1.FACEAMOUNT -- 票面金额
    ,P1.BILLNO -- 发票编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 发票日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.DUEDATE) -- 发票到期日期
    ,P1.USEDTIME -- 账龄
    ,P1.PAYOR -- 付款人名称
    ,NVL(TRIM(P1.ISHANDLE),'-') -- 破产清算标志
    ,P1.PAYORACCOUNT -- 付款人账户编号
    ,NVL(TRIM(P1.ISNOTICE),'-') -- 通知应收账款义务人标志
    ,NVL(TRIM(P1.ISPRODUCE),'-') -- 债权产生标志
    ,P1.REMARK -- 其他说明
    ,NVL(TRIM(P1.ISRELATION2),'-') -- 关系标志
    ,NVL(TRIM(P1.TDCURRENCY),'CNY') -- 币种代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_receivables' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_receivables p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_tm 
  	                                group by 
  	                                        asset_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,lc_num -- 信用证号码
    ,fac_val_amt -- 票面金额
    ,inv_id -- 发票编号
    ,inv_dt -- 发票日期
    ,inv_exp_dt -- 发票到期日期
    ,aging -- 账龄
    ,payer_name -- 付款人名称
    ,bkrpt_clear_flg -- 破产清算标志
    ,payer_acct_id -- 付款人账户编号
    ,advise_acct_recvbl_flg -- 通知应收账款义务人标志
    ,cred_rht_prod_flg -- 债权产生标志
    ,other_comnt -- 其他说明
    ,rela_flg -- 关系标志
    ,curr_cd -- 币种代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.lc_num, o.lc_num) as lc_num -- 信用证号码
    ,nvl(n.fac_val_amt, o.fac_val_amt) as fac_val_amt -- 票面金额
    ,nvl(n.inv_id, o.inv_id) as inv_id -- 发票编号
    ,nvl(n.inv_dt, o.inv_dt) as inv_dt -- 发票日期
    ,nvl(n.inv_exp_dt, o.inv_exp_dt) as inv_exp_dt -- 发票到期日期
    ,nvl(n.aging, o.aging) as aging -- 账龄
    ,nvl(n.payer_name, o.payer_name) as payer_name -- 付款人名称
    ,nvl(n.bkrpt_clear_flg, o.bkrpt_clear_flg) as bkrpt_clear_flg -- 破产清算标志
    ,nvl(n.payer_acct_id, o.payer_acct_id) as payer_acct_id -- 付款人账户编号
    ,nvl(n.advise_acct_recvbl_flg, o.advise_acct_recvbl_flg) as advise_acct_recvbl_flg -- 通知应收账款义务人标志
    ,nvl(n.cred_rht_prod_flg, o.cred_rht_prod_flg) as cred_rht_prod_flg -- 债权产生标志
    ,nvl(n.other_comnt, o.other_comnt) as other_comnt -- 其他说明
    ,nvl(n.rela_flg, o.rela_flg) as rela_flg -- 关系标志
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.lc_num <> n.lc_num
                or o.fac_val_amt <> n.fac_val_amt
                or o.inv_id <> n.inv_id
                or o.inv_dt <> n.inv_dt
                or o.inv_exp_dt <> n.inv_exp_dt
                or o.aging <> n.aging
                or o.payer_name <> n.payer_name
                or o.bkrpt_clear_flg <> n.bkrpt_clear_flg
                or o.payer_acct_id <> n.payer_acct_id
                or o.advise_acct_recvbl_flg <> n.advise_acct_recvbl_flg
                or o.cred_rht_prod_flg <> n.cred_rht_prod_flg
                or o.other_comnt <> n.other_comnt
                or o.rela_flg <> n.rela_flg
                or o.curr_cd <> n.curr_cd
            ) or (
                 case when (
                           n.asset_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_tm n
    full join ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_col_tran_recvbl_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_col_tran_recvbl_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_col_tran_recvbl_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_col_tran_recvbl_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_col_tran_recvbl_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_col_tran_recvbl_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);