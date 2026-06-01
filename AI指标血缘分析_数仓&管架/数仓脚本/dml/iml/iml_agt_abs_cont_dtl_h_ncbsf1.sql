/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_abs_cont_dtl_h_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_abs_cont_dtl_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_cont_dtl_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,asset_bag_cont_id -- 资产包合同编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,accti_status_cd -- 核算状态代码
    ,bal -- 余额
    ,asset_acct_status_cd -- 资产账户状态代码
    ,issue_batch_no -- 发行批次号
    ,issue_flow_num -- 发行流水号
    ,issue_convt_prem -- 发行折溢价
    ,issue_revo_batch_no -- 发行撤销批次号
    ,circl_buy_flg -- 循环购买标志
    ,circl_buy_batch_no -- 循环购买批次号
    ,circl_buy_flow_num -- 循环购买流水号
    ,circl_buy_dt -- 循环购买日期
    ,revo_pkg_batch_no -- 撤包批次号
    ,revo_pkg_tran_flow_num -- 撤包交易流水号
    ,revo_tran_ref_no -- 撤销交易参考号
    ,redem_tran_flow_num -- 赎回交易流水号
    ,redem_batch_no -- 赎回批次号
    ,redem_convt_prem -- 赎回折溢价
    ,pkg_batch_no -- 封包批次号
    ,pkg_flow_num -- 封包流水号
    ,pkg_tran_dt -- 封包交易日期
    ,tran_code_descb -- 交易码描述
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_cont_dtl_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_cont_dtl_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_abs_cont_dtl_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_transfer_detail-1
insert into ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,asset_bag_cont_id -- 资产包合同编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,accti_status_cd -- 核算状态代码
    ,bal -- 余额
    ,asset_acct_status_cd -- 资产账户状态代码
    ,issue_batch_no -- 发行批次号
    ,issue_flow_num -- 发行流水号
    ,issue_convt_prem -- 发行折溢价
    ,issue_revo_batch_no -- 发行撤销批次号
    ,circl_buy_flg -- 循环购买标志
    ,circl_buy_batch_no -- 循环购买批次号
    ,circl_buy_flow_num -- 循环购买流水号
    ,circl_buy_dt -- 循环购买日期
    ,revo_pkg_batch_no -- 撤包批次号
    ,revo_pkg_tran_flow_num -- 撤包交易流水号
    ,revo_tran_ref_no -- 撤销交易参考号
    ,redem_tran_flow_num -- 赎回交易流水号
    ,redem_batch_no -- 赎回批次号
    ,redem_convt_prem -- 赎回折溢价
    ,pkg_batch_no -- 封包批次号
    ,pkg_flow_num -- 封包流水号
    ,pkg_tran_dt -- 封包交易日期
    ,tran_code_descb -- 交易码描述
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300015'||P1.ASSET_CONTRACT_SEQ_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ASSET_DETAIL_SEQ_NO -- 资产包合同明细序号
    ,P1.ASSET_CONTRACT_SEQ_NO -- 资产包合同编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.DD_NO -- 放款流水号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.CCY -- 币种代码
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.ACCOUNTING_STATUS),'-') -- 核算状态代码
    ,P1.BALANCE -- 余额
    ,nvl(trim(P1.ASSET_ACCT_STATUS),'-') -- 资产账户状态代码
    ,P1.SALE_BATCH_NO -- 发行批次号
    ,P1.SALE_REFERENCE -- 发行流水号
    ,P1.SALE_FLOAT_AMOUNT -- 发行折溢价
    ,P1.SALE_CANCEL_BATCH_NO -- 发行撤销批次号
    ,P1.CIRCLE_BUY_FLAG -- 循环购买标志
    ,P1.CIRCLE_BUY_BATCH_NO -- 循环购买批次号
    ,P1.CIRCLE_BUY_REFERENCE -- 循环购买流水号
    ,P1.CIRCLE_BUY_DATE -- 循环购买日期
    ,P1.PACK_CANCEL_BATCH_NO -- 撤包批次号
    ,P1.PACK_CANCEL_REFERENCE -- 撤包交易流水号
    ,P1.SALE_CANCEL_REFERENCE -- 撤销交易参考号
    ,P1.REDEEM_REFERENCE -- 赎回交易流水号
    ,P1.REDEEM_BATCH_NO -- 赎回批次号
    ,P1.REDEEM_FLOAT_AMOUNT -- 赎回折溢价
    ,P1.PACK_BATCH_NO -- 封包批次号
    ,P1.PACK_REFERENCE -- 封包流水号
    ,P1.PACK_TRAN_DATE -- 封包交易日期
    ,P1.NARRATIVE -- 交易码描述
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_transfer_detail' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_transfer_detail p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,asset_bag_cont_dtl_seq_num
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,asset_bag_cont_id -- 资产包合同编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,accti_status_cd -- 核算状态代码
    ,bal -- 余额
    ,asset_acct_status_cd -- 资产账户状态代码
    ,issue_batch_no -- 发行批次号
    ,issue_flow_num -- 发行流水号
    ,issue_convt_prem -- 发行折溢价
    ,issue_revo_batch_no -- 发行撤销批次号
    ,circl_buy_flg -- 循环购买标志
    ,circl_buy_batch_no -- 循环购买批次号
    ,circl_buy_flow_num -- 循环购买流水号
    ,circl_buy_dt -- 循环购买日期
    ,revo_pkg_batch_no -- 撤包批次号
    ,revo_pkg_tran_flow_num -- 撤包交易流水号
    ,revo_tran_ref_no -- 撤销交易参考号
    ,redem_tran_flow_num -- 赎回交易流水号
    ,redem_batch_no -- 赎回批次号
    ,redem_convt_prem -- 赎回折溢价
    ,pkg_batch_no -- 封包批次号
    ,pkg_flow_num -- 封包流水号
    ,pkg_tran_dt -- 封包交易日期
    ,tran_code_descb -- 交易码描述
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,asset_bag_cont_id -- 资产包合同编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,accti_status_cd -- 核算状态代码
    ,bal -- 余额
    ,asset_acct_status_cd -- 资产账户状态代码
    ,issue_batch_no -- 发行批次号
    ,issue_flow_num -- 发行流水号
    ,issue_convt_prem -- 发行折溢价
    ,issue_revo_batch_no -- 发行撤销批次号
    ,circl_buy_flg -- 循环购买标志
    ,circl_buy_batch_no -- 循环购买批次号
    ,circl_buy_flow_num -- 循环购买流水号
    ,circl_buy_dt -- 循环购买日期
    ,revo_pkg_batch_no -- 撤包批次号
    ,revo_pkg_tran_flow_num -- 撤包交易流水号
    ,revo_tran_ref_no -- 撤销交易参考号
    ,redem_tran_flow_num -- 赎回交易流水号
    ,redem_batch_no -- 赎回批次号
    ,redem_convt_prem -- 赎回折溢价
    ,pkg_batch_no -- 封包批次号
    ,pkg_flow_num -- 封包流水号
    ,pkg_tran_dt -- 封包交易日期
    ,tran_code_descb -- 交易码描述
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.asset_bag_cont_dtl_seq_num, o.asset_bag_cont_dtl_seq_num) as asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,nvl(n.asset_bag_cont_id, o.asset_bag_cont_id) as asset_bag_cont_id -- 资产包合同编号
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.distr_flow_num, o.distr_flow_num) as distr_flow_num -- 放款流水号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.bal, o.bal) as bal -- 余额
    ,nvl(n.asset_acct_status_cd, o.asset_acct_status_cd) as asset_acct_status_cd -- 资产账户状态代码
    ,nvl(n.issue_batch_no, o.issue_batch_no) as issue_batch_no -- 发行批次号
    ,nvl(n.issue_flow_num, o.issue_flow_num) as issue_flow_num -- 发行流水号
    ,nvl(n.issue_convt_prem, o.issue_convt_prem) as issue_convt_prem -- 发行折溢价
    ,nvl(n.issue_revo_batch_no, o.issue_revo_batch_no) as issue_revo_batch_no -- 发行撤销批次号
    ,nvl(n.circl_buy_flg, o.circl_buy_flg) as circl_buy_flg -- 循环购买标志
    ,nvl(n.circl_buy_batch_no, o.circl_buy_batch_no) as circl_buy_batch_no -- 循环购买批次号
    ,nvl(n.circl_buy_flow_num, o.circl_buy_flow_num) as circl_buy_flow_num -- 循环购买流水号
    ,nvl(n.circl_buy_dt, o.circl_buy_dt) as circl_buy_dt -- 循环购买日期
    ,nvl(n.revo_pkg_batch_no, o.revo_pkg_batch_no) as revo_pkg_batch_no -- 撤包批次号
    ,nvl(n.revo_pkg_tran_flow_num, o.revo_pkg_tran_flow_num) as revo_pkg_tran_flow_num -- 撤包交易流水号
    ,nvl(n.revo_tran_ref_no, o.revo_tran_ref_no) as revo_tran_ref_no -- 撤销交易参考号
    ,nvl(n.redem_tran_flow_num, o.redem_tran_flow_num) as redem_tran_flow_num -- 赎回交易流水号
    ,nvl(n.redem_batch_no, o.redem_batch_no) as redem_batch_no -- 赎回批次号
    ,nvl(n.redem_convt_prem, o.redem_convt_prem) as redem_convt_prem -- 赎回折溢价
    ,nvl(n.pkg_batch_no, o.pkg_batch_no) as pkg_batch_no -- 封包批次号
    ,nvl(n.pkg_flow_num, o.pkg_flow_num) as pkg_flow_num -- 封包流水号
    ,nvl(n.pkg_tran_dt, o.pkg_tran_dt) as pkg_tran_dt -- 封包交易日期
    ,nvl(n.tran_code_descb, o.tran_code_descb) as tran_code_descb -- 交易码描述
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_bag_cont_dtl_seq_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_bag_cont_dtl_seq_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.asset_bag_cont_dtl_seq_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.asset_bag_cont_dtl_seq_num = n.asset_bag_cont_dtl_seq_num
where (
        o.agt_id is null
        and o.lp_id is null
        and o.asset_bag_cont_dtl_seq_num is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.asset_bag_cont_dtl_seq_num is null
    )
    or (
        o.asset_bag_cont_id <> n.asset_bag_cont_id
        or o.loan_num <> n.loan_num
        or o.distr_flow_num <> n.distr_flow_num
        or o.prod_id <> n.prod_id
        or o.dubil_id <> n.dubil_id
        or o.curr_cd <> n.curr_cd
        or o.acct_id <> n.acct_id
        or o.cust_id <> n.cust_id
        or o.accti_status_cd <> n.accti_status_cd
        or o.bal <> n.bal
        or o.asset_acct_status_cd <> n.asset_acct_status_cd
        or o.issue_batch_no <> n.issue_batch_no
        or o.issue_flow_num <> n.issue_flow_num
        or o.issue_convt_prem <> n.issue_convt_prem
        or o.issue_revo_batch_no <> n.issue_revo_batch_no
        or o.circl_buy_flg <> n.circl_buy_flg
        or o.circl_buy_batch_no <> n.circl_buy_batch_no
        or o.circl_buy_flow_num <> n.circl_buy_flow_num
        or o.circl_buy_dt <> n.circl_buy_dt
        or o.revo_pkg_batch_no <> n.revo_pkg_batch_no
        or o.revo_pkg_tran_flow_num <> n.revo_pkg_tran_flow_num
        or o.revo_tran_ref_no <> n.revo_tran_ref_no
        or o.redem_tran_flow_num <> n.redem_tran_flow_num
        or o.redem_batch_no <> n.redem_batch_no
        or o.redem_convt_prem <> n.redem_convt_prem
        or o.pkg_batch_no <> n.pkg_batch_no
        or o.pkg_flow_num <> n.pkg_flow_num
        or o.pkg_tran_dt <> n.pkg_tran_dt
        or o.tran_code_descb <> n.tran_code_descb
        or o.final_modif_dt <> n.final_modif_dt
        or o.tran_tm <> n.tran_tm
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,asset_bag_cont_id -- 资产包合同编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,accti_status_cd -- 核算状态代码
    ,bal -- 余额
    ,asset_acct_status_cd -- 资产账户状态代码
    ,issue_batch_no -- 发行批次号
    ,issue_flow_num -- 发行流水号
    ,issue_convt_prem -- 发行折溢价
    ,issue_revo_batch_no -- 发行撤销批次号
    ,circl_buy_flg -- 循环购买标志
    ,circl_buy_batch_no -- 循环购买批次号
    ,circl_buy_flow_num -- 循环购买流水号
    ,circl_buy_dt -- 循环购买日期
    ,revo_pkg_batch_no -- 撤包批次号
    ,revo_pkg_tran_flow_num -- 撤包交易流水号
    ,revo_tran_ref_no -- 撤销交易参考号
    ,redem_tran_flow_num -- 赎回交易流水号
    ,redem_batch_no -- 赎回批次号
    ,redem_convt_prem -- 赎回折溢价
    ,pkg_batch_no -- 封包批次号
    ,pkg_flow_num -- 封包流水号
    ,pkg_tran_dt -- 封包交易日期
    ,tran_code_descb -- 交易码描述
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,asset_bag_cont_id -- 资产包合同编号
    ,loan_num -- 贷款号
    ,distr_flow_num -- 放款流水号
    ,prod_id -- 产品编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,accti_status_cd -- 核算状态代码
    ,bal -- 余额
    ,asset_acct_status_cd -- 资产账户状态代码
    ,issue_batch_no -- 发行批次号
    ,issue_flow_num -- 发行流水号
    ,issue_convt_prem -- 发行折溢价
    ,issue_revo_batch_no -- 发行撤销批次号
    ,circl_buy_flg -- 循环购买标志
    ,circl_buy_batch_no -- 循环购买批次号
    ,circl_buy_flow_num -- 循环购买流水号
    ,circl_buy_dt -- 循环购买日期
    ,revo_pkg_batch_no -- 撤包批次号
    ,revo_pkg_tran_flow_num -- 撤包交易流水号
    ,revo_tran_ref_no -- 撤销交易参考号
    ,redem_tran_flow_num -- 赎回交易流水号
    ,redem_batch_no -- 赎回批次号
    ,redem_convt_prem -- 赎回折溢价
    ,pkg_batch_no -- 封包批次号
    ,pkg_flow_num -- 封包流水号
    ,pkg_tran_dt -- 封包交易日期
    ,tran_code_descb -- 交易码描述
    ,final_modif_dt -- 最后修改日期
    ,tran_tm -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.asset_bag_cont_dtl_seq_num -- 资产包合同明细序号
    ,o.asset_bag_cont_id -- 资产包合同编号
    ,o.loan_num -- 贷款号
    ,o.distr_flow_num -- 放款流水号
    ,o.prod_id -- 产品编号
    ,o.dubil_id -- 借据编号
    ,o.curr_cd -- 币种代码
    ,o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.accti_status_cd -- 核算状态代码
    ,o.bal -- 余额
    ,o.asset_acct_status_cd -- 资产账户状态代码
    ,o.issue_batch_no -- 发行批次号
    ,o.issue_flow_num -- 发行流水号
    ,o.issue_convt_prem -- 发行折溢价
    ,o.issue_revo_batch_no -- 发行撤销批次号
    ,o.circl_buy_flg -- 循环购买标志
    ,o.circl_buy_batch_no -- 循环购买批次号
    ,o.circl_buy_flow_num -- 循环购买流水号
    ,o.circl_buy_dt -- 循环购买日期
    ,o.revo_pkg_batch_no -- 撤包批次号
    ,o.revo_pkg_tran_flow_num -- 撤包交易流水号
    ,o.revo_tran_ref_no -- 撤销交易参考号
    ,o.redem_tran_flow_num -- 赎回交易流水号
    ,o.redem_batch_no -- 赎回批次号
    ,o.redem_convt_prem -- 赎回折溢价
    ,o.pkg_batch_no -- 封包批次号
    ,o.pkg_flow_num -- 封包流水号
    ,o.pkg_tran_dt -- 封包交易日期
    ,o.tran_code_descb -- 交易码描述
    ,o.final_modif_dt -- 最后修改日期
    ,o.tran_tm -- 交易时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_bk o
    left join ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.asset_bag_cont_dtl_seq_num = n.asset_bag_cont_dtl_seq_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.asset_bag_cont_dtl_seq_num = d.asset_bag_cont_dtl_seq_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_abs_cont_dtl_h;
--alter table ${iml_schema}.agt_abs_cont_dtl_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_abs_cont_dtl_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_abs_cont_dtl_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_abs_cont_dtl_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_abs_cont_dtl_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl;
alter table ${iml_schema}.agt_abs_cont_dtl_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_abs_cont_dtl_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_abs_cont_dtl_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_abs_cont_dtl_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
