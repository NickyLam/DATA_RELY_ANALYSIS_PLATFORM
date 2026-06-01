/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ibank_payfan_rgst_info_h_isbsf1
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
alter table ${iml_schema}.agt_ibank_payfan_rgst_info_h add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_isbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_payfan_rgst_info_h partition for ('isbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_inr -- 交易INR
    ,rela_table_name -- 关联表名称
    ,rela_tab_inr -- 关联表INR
    ,tran_id -- 交易编号
    ,ths_tm_payfan_pric -- 本次代付本金
    ,ths_tm_payfan_int -- 本次代付利息
    ,ths_tm_payfan_pnlt -- 本次代付罚息
    ,payfan_value_dt -- 代付起息日期
    ,payfan_exp_dt -- 代付到期日期
    ,int_accr_base_cd -- 计息基准代码
    ,curr_cd -- 币种代码
    ,ovdue_int_rat -- 逾期利率
    ,payfan_pnlt_int_rat -- 代付罚息利率
    ,entry_amt -- 记账金额
    ,int_adj_amt -- 利息调整金额
    ,pnlt_adj_amt -- 罚息调整金额
    ,oper_type_cd -- 操作类型代码
    ,dubil_id -- 借据编号
    ,pay_cont_id -- 付款合同编号
    ,applit_cust_id -- 申请人客户编号
    ,final_coll_flg -- 最后一次归集标志
    ,belong_org_id -- 所属机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_payfan_rgst_info_h partition for ('isbsf1')
where 0=1
;

create table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_payfan_rgst_info_h partition for ('isbsf1') where 0=1;

create table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ibank_payfan_rgst_info_h partition for ('isbsf1') where 0=1;

-- 3.1 get new data into table
-- isbs_djb-1
insert into ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_inr -- 交易INR
    ,rela_table_name -- 关联表名称
    ,rela_tab_inr -- 关联表INR
    ,tran_id -- 交易编号
    ,ths_tm_payfan_pric -- 本次代付本金
    ,ths_tm_payfan_int -- 本次代付利息
    ,ths_tm_payfan_pnlt -- 本次代付罚息
    ,payfan_value_dt -- 代付起息日期
    ,payfan_exp_dt -- 代付到期日期
    ,int_accr_base_cd -- 计息基准代码
    ,curr_cd -- 币种代码
    ,ovdue_int_rat -- 逾期利率
    ,payfan_pnlt_int_rat -- 代付罚息利率
    ,entry_amt -- 记账金额
    ,int_adj_amt -- 利息调整金额
    ,pnlt_adj_amt -- 罚息调整金额
    ,oper_type_cd -- 操作类型代码
    ,dubil_id -- 借据编号
    ,pay_cont_id -- 付款合同编号
    ,applit_cust_id -- 申请人客户编号
    ,final_coll_flg -- 最后一次归集标志
    ,belong_org_id -- 所属机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300039'||P1.INR -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INR -- 交易流水号
    ,P1.TRNINR -- 交易INR
    ,P1.OBJTYP -- 关联表名称
    ,P1.OBJINR -- 关联表INR
    ,P1.OWNREF -- 交易编号
    ,P1.THISAMT -- 本次代付本金
    ,P1.THISINT -- 本次代付利息
    ,P1.THISDEFINT -- 本次代付罚息
    ,P1.STTTENDAT -- 代付起息日期
    ,P1.MATDAT -- 代付到期日期
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'|| P1.IRTMIC end -- 计息基准代码
    ,nvl(trim(P1.CUR),'-') -- 币种代码
    ,P1.DFRATE -- 逾期利率
    ,P1.DFDELRATE -- 代付罚息利率
    ,P1.AMT -- 记账金额
    ,P1.INTADJAMT -- 利息调整金额
    ,P1.DELADJAMT -- 罚息调整金额
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else '@'|| P1.OPERTYP end -- 操作类型代码
    ,P1.JJH -- 借据编号
    ,P1.SL_CONTRACT_NO -- 付款合同编号
    ,P1.EXTKEY -- 申请人客户编号
    ,decode(trim(P1.IFLASTCOL),'Y','1','N','0','','-') -- 最后一次归集标志
    ,P1.HOME_BRANCH -- 所属机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_djb' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_djb p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.IRTMIC = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ISBS'
        AND R1.SRC_TAB_EN_NAME= 'ISBS_DJB'
        AND R1.SRC_FIELD_EN_NAME= 'IRTMIC'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_IBANK_PAYFAN_RGST_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_ACCR_BASE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.OPERTYP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ISBS'
        AND R2.SRC_TAB_EN_NAME= 'ISBS_DJB'
        AND R2.SRC_FIELD_EN_NAME= 'OPERTYP'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_IBANK_PAYFAN_RGST_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'OPER_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_tm 
  	                                group by 
  	                                        agt_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_inr -- 交易INR
    ,rela_table_name -- 关联表名称
    ,rela_tab_inr -- 关联表INR
    ,tran_id -- 交易编号
    ,ths_tm_payfan_pric -- 本次代付本金
    ,ths_tm_payfan_int -- 本次代付利息
    ,ths_tm_payfan_pnlt -- 本次代付罚息
    ,payfan_value_dt -- 代付起息日期
    ,payfan_exp_dt -- 代付到期日期
    ,int_accr_base_cd -- 计息基准代码
    ,curr_cd -- 币种代码
    ,ovdue_int_rat -- 逾期利率
    ,payfan_pnlt_int_rat -- 代付罚息利率
    ,entry_amt -- 记账金额
    ,int_adj_amt -- 利息调整金额
    ,pnlt_adj_amt -- 罚息调整金额
    ,oper_type_cd -- 操作类型代码
    ,dubil_id -- 借据编号
    ,pay_cont_id -- 付款合同编号
    ,applit_cust_id -- 申请人客户编号
    ,final_coll_flg -- 最后一次归集标志
    ,belong_org_id -- 所属机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_inr -- 交易INR
    ,rela_table_name -- 关联表名称
    ,rela_tab_inr -- 关联表INR
    ,tran_id -- 交易编号
    ,ths_tm_payfan_pric -- 本次代付本金
    ,ths_tm_payfan_int -- 本次代付利息
    ,ths_tm_payfan_pnlt -- 本次代付罚息
    ,payfan_value_dt -- 代付起息日期
    ,payfan_exp_dt -- 代付到期日期
    ,int_accr_base_cd -- 计息基准代码
    ,curr_cd -- 币种代码
    ,ovdue_int_rat -- 逾期利率
    ,payfan_pnlt_int_rat -- 代付罚息利率
    ,entry_amt -- 记账金额
    ,int_adj_amt -- 利息调整金额
    ,pnlt_adj_amt -- 罚息调整金额
    ,oper_type_cd -- 操作类型代码
    ,dubil_id -- 借据编号
    ,pay_cont_id -- 付款合同编号
    ,applit_cust_id -- 申请人客户编号
    ,final_coll_flg -- 最后一次归集标志
    ,belong_org_id -- 所属机构编号
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
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_inr, o.tran_inr) as tran_inr -- 交易INR
    ,nvl(n.rela_table_name, o.rela_table_name) as rela_table_name -- 关联表名称
    ,nvl(n.rela_tab_inr, o.rela_tab_inr) as rela_tab_inr -- 关联表INR
    ,nvl(n.tran_id, o.tran_id) as tran_id -- 交易编号
    ,nvl(n.ths_tm_payfan_pric, o.ths_tm_payfan_pric) as ths_tm_payfan_pric -- 本次代付本金
    ,nvl(n.ths_tm_payfan_int, o.ths_tm_payfan_int) as ths_tm_payfan_int -- 本次代付利息
    ,nvl(n.ths_tm_payfan_pnlt, o.ths_tm_payfan_pnlt) as ths_tm_payfan_pnlt -- 本次代付罚息
    ,nvl(n.payfan_value_dt, o.payfan_value_dt) as payfan_value_dt -- 代付起息日期
    ,nvl(n.payfan_exp_dt, o.payfan_exp_dt) as payfan_exp_dt -- 代付到期日期
    ,nvl(n.int_accr_base_cd, o.int_accr_base_cd) as int_accr_base_cd -- 计息基准代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.payfan_pnlt_int_rat, o.payfan_pnlt_int_rat) as payfan_pnlt_int_rat -- 代付罚息利率
    ,nvl(n.entry_amt, o.entry_amt) as entry_amt -- 记账金额
    ,nvl(n.int_adj_amt, o.int_adj_amt) as int_adj_amt -- 利息调整金额
    ,nvl(n.pnlt_adj_amt, o.pnlt_adj_amt) as pnlt_adj_amt -- 罚息调整金额
    ,nvl(n.oper_type_cd, o.oper_type_cd) as oper_type_cd -- 操作类型代码
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.pay_cont_id, o.pay_cont_id) as pay_cont_id -- 付款合同编号
    ,nvl(n.applit_cust_id, o.applit_cust_id) as applit_cust_id -- 申请人客户编号
    ,nvl(n.final_coll_flg, o.final_coll_flg) as final_coll_flg -- 最后一次归集标志
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_tm n
    full join (select * from ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.tran_flow_num <> n.tran_flow_num
        or o.tran_inr <> n.tran_inr
        or o.rela_table_name <> n.rela_table_name
        or o.rela_tab_inr <> n.rela_tab_inr
        or o.tran_id <> n.tran_id
        or o.ths_tm_payfan_pric <> n.ths_tm_payfan_pric
        or o.ths_tm_payfan_int <> n.ths_tm_payfan_int
        or o.ths_tm_payfan_pnlt <> n.ths_tm_payfan_pnlt
        or o.payfan_value_dt <> n.payfan_value_dt
        or o.payfan_exp_dt <> n.payfan_exp_dt
        or o.int_accr_base_cd <> n.int_accr_base_cd
        or o.curr_cd <> n.curr_cd
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.payfan_pnlt_int_rat <> n.payfan_pnlt_int_rat
        or o.entry_amt <> n.entry_amt
        or o.int_adj_amt <> n.int_adj_amt
        or o.pnlt_adj_amt <> n.pnlt_adj_amt
        or o.oper_type_cd <> n.oper_type_cd
        or o.dubil_id <> n.dubil_id
        or o.pay_cont_id <> n.pay_cont_id
        or o.applit_cust_id <> n.applit_cust_id
        or o.final_coll_flg <> n.final_coll_flg
        or o.belong_org_id <> n.belong_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_inr -- 交易INR
    ,rela_table_name -- 关联表名称
    ,rela_tab_inr -- 关联表INR
    ,tran_id -- 交易编号
    ,ths_tm_payfan_pric -- 本次代付本金
    ,ths_tm_payfan_int -- 本次代付利息
    ,ths_tm_payfan_pnlt -- 本次代付罚息
    ,payfan_value_dt -- 代付起息日期
    ,payfan_exp_dt -- 代付到期日期
    ,int_accr_base_cd -- 计息基准代码
    ,curr_cd -- 币种代码
    ,ovdue_int_rat -- 逾期利率
    ,payfan_pnlt_int_rat -- 代付罚息利率
    ,entry_amt -- 记账金额
    ,int_adj_amt -- 利息调整金额
    ,pnlt_adj_amt -- 罚息调整金额
    ,oper_type_cd -- 操作类型代码
    ,dubil_id -- 借据编号
    ,pay_cont_id -- 付款合同编号
    ,applit_cust_id -- 申请人客户编号
    ,final_coll_flg -- 最后一次归集标志
    ,belong_org_id -- 所属机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,tran_inr -- 交易INR
    ,rela_table_name -- 关联表名称
    ,rela_tab_inr -- 关联表INR
    ,tran_id -- 交易编号
    ,ths_tm_payfan_pric -- 本次代付本金
    ,ths_tm_payfan_int -- 本次代付利息
    ,ths_tm_payfan_pnlt -- 本次代付罚息
    ,payfan_value_dt -- 代付起息日期
    ,payfan_exp_dt -- 代付到期日期
    ,int_accr_base_cd -- 计息基准代码
    ,curr_cd -- 币种代码
    ,ovdue_int_rat -- 逾期利率
    ,payfan_pnlt_int_rat -- 代付罚息利率
    ,entry_amt -- 记账金额
    ,int_adj_amt -- 利息调整金额
    ,pnlt_adj_amt -- 罚息调整金额
    ,oper_type_cd -- 操作类型代码
    ,dubil_id -- 借据编号
    ,pay_cont_id -- 付款合同编号
    ,applit_cust_id -- 申请人客户编号
    ,final_coll_flg -- 最后一次归集标志
    ,belong_org_id -- 所属机构编号
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
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_inr -- 交易INR
    ,o.rela_table_name -- 关联表名称
    ,o.rela_tab_inr -- 关联表INR
    ,o.tran_id -- 交易编号
    ,o.ths_tm_payfan_pric -- 本次代付本金
    ,o.ths_tm_payfan_int -- 本次代付利息
    ,o.ths_tm_payfan_pnlt -- 本次代付罚息
    ,o.payfan_value_dt -- 代付起息日期
    ,o.payfan_exp_dt -- 代付到期日期
    ,o.int_accr_base_cd -- 计息基准代码
    ,o.curr_cd -- 币种代码
    ,o.ovdue_int_rat -- 逾期利率
    ,o.payfan_pnlt_int_rat -- 代付罚息利率
    ,o.entry_amt -- 记账金额
    ,o.int_adj_amt -- 利息调整金额
    ,o.pnlt_adj_amt -- 罚息调整金额
    ,o.oper_type_cd -- 操作类型代码
    ,o.dubil_id -- 借据编号
    ,o.pay_cont_id -- 付款合同编号
    ,o.applit_cust_id -- 申请人客户编号
    ,o.final_coll_flg -- 最后一次归集标志
    ,o.belong_org_id -- 所属机构编号
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
from ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_bk o
    left join ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_ibank_payfan_rgst_info_h;
--alter table ${iml_schema}.agt_ibank_payfan_rgst_info_h truncate partition for ('isbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_ibank_payfan_rgst_info_h') 
               and substr(subpartition_name,1,8)=upper('p_isbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_ibank_payfan_rgst_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_ibank_payfan_rgst_info_h modify partition p_isbsf1 
add subpartition p_isbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_ibank_payfan_rgst_info_h exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl;
alter table ${iml_schema}.agt_ibank_payfan_rgst_info_h exchange subpartition p_isbsf1_20991231 with table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ibank_payfan_rgst_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_tm purge;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_op purge;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_ibank_payfan_rgst_info_h_isbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ibank_payfan_rgst_info_h', partname => 'p_isbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
