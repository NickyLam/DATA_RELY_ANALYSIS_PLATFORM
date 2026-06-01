/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_dubil_mini_loan_attach_info_h_icmsf1
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
alter table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,int_accr_way_cd -- 计息方式代码
    ,ped_cd -- 周期代码
    ,loan_kind_cd -- 贷款种类代码
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,unpay_nomal_int -- 未结正常利息
    ,pre_recv_int_flg -- 收息标志
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ovdue_nomal_pric -- 逾期正常本金
    ,ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,next_term_repay_int_amt -- 下一期还息金额
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_repay_int_dt -- 下一期还息日期
    ,modif_post_repay_num_name -- 变更后还款账户名称
    ,modif_post_repay_num_id -- 变更后还款账户编号
    ,buy_out_liqd_flg -- 买断清收标志
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,wrtoff_dt -- 销账日期
    ,wrt_off_cate_cd -- 核销类别代码
    ,dubil_bal -- 借据余额
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_bd_upl_loan-1
insert into ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,int_accr_way_cd -- 计息方式代码
    ,ped_cd -- 周期代码
    ,loan_kind_cd -- 贷款种类代码
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,unpay_nomal_int -- 未结正常利息
    ,pre_recv_int_flg -- 收息标志
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ovdue_nomal_pric -- 逾期正常本金
    ,ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,next_term_repay_int_amt -- 下一期还息金额
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_repay_int_dt -- 下一期还息日期
    ,modif_post_repay_num_name -- 变更后还款账户名称
    ,modif_post_repay_num_id -- 变更后还款账户编号
    ,buy_out_liqd_flg -- 买断清收标志
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,wrtoff_dt -- 销账日期
    ,wrt_off_cate_cd -- 核销类别代码
    ,dubil_bal -- 借据余额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.SERIALNO -- 协议编号
    ,P1.SERIALNO -- 借据编号
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,P1.SURPLUSPHASES -- 剩余期数
    ,nvl(trim(P1.ACCEPTINTTYPE),'-') -- 计息方式代码
    ,nvl(trim(P1.FIXTERM),'-') -- 周期代码
    ,nvl(trim(P1.LOANSPECIES),'-') -- 贷款种类代码
    ,P1.EACMPRINCIPAL -- 每期扣款金额
    ,P1.RACCRINT -- 未结正常利息
    ,nvl(trim(P1.PREINTTYPE),'-') -- 收息标志
    ,P1.YQFULI -- 逾期复利
    ,P1.YQINTEREST -- 逾期利息
    ,P1.YQFAXI -- 逾期罚息
    ,P1.YQNORMALBALANCE -- 逾期正常本金
    ,P1.YQTOTALSUM -- 逾期累计应还金额
    ,P1.YQBADBALANCE -- 逾期管理逾期本金
    ,P1.NEXTPERIODRETURNINTERESTSUM -- 下一期还息金额
    ,P1.NEXTPERIODRETURNPRINCIPALSUM -- 下一期还本金额
    ,${iml_schema}.dateformat_max2(P1.NEXTPERIODRETURNPRINCIPALDATE) -- 下一期还本日期
    ,${iml_schema}.dateformat_max2(P1.NEXTPERIODRETURNINTERESTDATE) -- 下一期还息日期
    ,P1.CHANGEPAYACCOUNTNAME -- 变更后还款账户名称
    ,P1.CHANGEPAYACCOUNTNO -- 变更后还款账户编号
    ,P1.BDFLAG -- 买断清收标志
    ,P1.HXINRATE -- 核销表内利息
    ,P1.HXOUTRATE -- 核销表外利息
    ,P1.LOGOUTDATE -- 销账日期
    ,nvl(trim(P1.HXTYPE),'-') -- 核销类别代码
    ,P1.DUEBALANCE -- 借据余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_bd_upl_loan' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_bd_upl_loan p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,dubil_id
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
        into ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,int_accr_way_cd -- 计息方式代码
    ,ped_cd -- 周期代码
    ,loan_kind_cd -- 贷款种类代码
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,unpay_nomal_int -- 未结正常利息
    ,pre_recv_int_flg -- 收息标志
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ovdue_nomal_pric -- 逾期正常本金
    ,ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,next_term_repay_int_amt -- 下一期还息金额
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_repay_int_dt -- 下一期还息日期
    ,modif_post_repay_num_name -- 变更后还款账户名称
    ,modif_post_repay_num_id -- 变更后还款账户编号
    ,buy_out_liqd_flg -- 买断清收标志
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,wrtoff_dt -- 销账日期
    ,wrt_off_cate_cd -- 核销类别代码
    ,dubil_bal -- 借据余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,int_accr_way_cd -- 计息方式代码
    ,ped_cd -- 周期代码
    ,loan_kind_cd -- 贷款种类代码
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,unpay_nomal_int -- 未结正常利息
    ,pre_recv_int_flg -- 收息标志
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ovdue_nomal_pric -- 逾期正常本金
    ,ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,next_term_repay_int_amt -- 下一期还息金额
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_repay_int_dt -- 下一期还息日期
    ,modif_post_repay_num_name -- 变更后还款账户名称
    ,modif_post_repay_num_id -- 变更后还款账户编号
    ,buy_out_liqd_flg -- 买断清收标志
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,wrtoff_dt -- 销账日期
    ,wrt_off_cate_cd -- 核销类别代码
    ,dubil_bal -- 借据余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.surp_perds, o.surp_perds) as surp_perds -- 剩余期数
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.ped_cd, o.ped_cd) as ped_cd -- 周期代码
    ,nvl(n.loan_kind_cd, o.loan_kind_cd) as loan_kind_cd -- 贷款种类代码
    ,nvl(n.eh_issue_deduct_amt, o.eh_issue_deduct_amt) as eh_issue_deduct_amt -- 每期扣款金额
    ,nvl(n.unpay_nomal_int, o.unpay_nomal_int) as unpay_nomal_int -- 未结正常利息
    ,nvl(n.pre_recv_int_flg, o.pre_recv_int_flg) as pre_recv_int_flg -- 收息标志
    ,nvl(n.ovdue_comp_int, o.ovdue_comp_int) as ovdue_comp_int -- 逾期复利
    ,nvl(n.ovdue_int, o.ovdue_int) as ovdue_int -- 逾期利息
    ,nvl(n.ovdue_pnlt, o.ovdue_pnlt) as ovdue_pnlt -- 逾期罚息
    ,nvl(n.ovdue_nomal_pric, o.ovdue_nomal_pric) as ovdue_nomal_pric -- 逾期正常本金
    ,nvl(n.ovdue_acm_rpbl_amt, o.ovdue_acm_rpbl_amt) as ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,nvl(n.ovdue_mgmt_ovdue_pric, o.ovdue_mgmt_ovdue_pric) as ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,nvl(n.next_term_repay_int_amt, o.next_term_repay_int_amt) as next_term_repay_int_amt -- 下一期还息金额
    ,nvl(n.next_term_rpp_amt, o.next_term_rpp_amt) as next_term_rpp_amt -- 下一期还本金额
    ,nvl(n.next_term_rpp_dt, o.next_term_rpp_dt) as next_term_rpp_dt -- 下一期还本日期
    ,nvl(n.next_term_repay_int_dt, o.next_term_repay_int_dt) as next_term_repay_int_dt -- 下一期还息日期
    ,nvl(n.modif_post_repay_num_name, o.modif_post_repay_num_name) as modif_post_repay_num_name -- 变更后还款账户名称
    ,nvl(n.modif_post_repay_num_id, o.modif_post_repay_num_id) as modif_post_repay_num_id -- 变更后还款账户编号
    ,nvl(n.buy_out_liqd_flg, o.buy_out_liqd_flg) as buy_out_liqd_flg -- 买断清收标志
    ,nvl(n.wrt_off_in_bs_int, o.wrt_off_in_bs_int) as wrt_off_in_bs_int -- 核销表内利息
    ,nvl(n.wrt_off_off_bs_int, o.wrt_off_off_bs_int) as wrt_off_off_bs_int -- 核销表外利息
    ,nvl(n.wrtoff_dt, o.wrtoff_dt) as wrtoff_dt -- 销账日期
    ,nvl(n.wrt_off_cate_cd, o.wrt_off_cate_cd) as wrt_off_cate_cd -- 核销类别代码
    ,nvl(n.dubil_bal, o.dubil_bal) as dubil_bal -- 借据余额
    ,case when
            n.agt_id is null
            and n.dubil_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.dubil_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.dubil_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.dubil_id = n.dubil_id
where (
        o.agt_id is null
        and o.dubil_id is null
    )
    or (
        n.agt_id is null
        and n.dubil_id is null
    )
    or (
        o.loan_type_cd <> n.loan_type_cd
        or o.surp_perds <> n.surp_perds
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.ped_cd <> n.ped_cd
        or o.loan_kind_cd <> n.loan_kind_cd
        or o.eh_issue_deduct_amt <> n.eh_issue_deduct_amt
        or o.unpay_nomal_int <> n.unpay_nomal_int
        or o.pre_recv_int_flg <> n.pre_recv_int_flg
        or o.ovdue_comp_int <> n.ovdue_comp_int
        or o.ovdue_int <> n.ovdue_int
        or o.ovdue_pnlt <> n.ovdue_pnlt
        or o.ovdue_nomal_pric <> n.ovdue_nomal_pric
        or o.ovdue_acm_rpbl_amt <> n.ovdue_acm_rpbl_amt
        or o.ovdue_mgmt_ovdue_pric <> n.ovdue_mgmt_ovdue_pric
        or o.next_term_repay_int_amt <> n.next_term_repay_int_amt
        or o.next_term_rpp_amt <> n.next_term_rpp_amt
        or o.next_term_rpp_dt <> n.next_term_rpp_dt
        or o.next_term_repay_int_dt <> n.next_term_repay_int_dt
        or o.modif_post_repay_num_name <> n.modif_post_repay_num_name
        or o.modif_post_repay_num_id <> n.modif_post_repay_num_id
        or o.buy_out_liqd_flg <> n.buy_out_liqd_flg
        or o.wrt_off_in_bs_int <> n.wrt_off_in_bs_int
        or o.wrt_off_off_bs_int <> n.wrt_off_off_bs_int
        or o.wrtoff_dt <> n.wrtoff_dt
        or o.wrt_off_cate_cd <> n.wrt_off_cate_cd
        or o.dubil_bal <> n.dubil_bal
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,int_accr_way_cd -- 计息方式代码
    ,ped_cd -- 周期代码
    ,loan_kind_cd -- 贷款种类代码
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,unpay_nomal_int -- 未结正常利息
    ,pre_recv_int_flg -- 收息标志
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ovdue_nomal_pric -- 逾期正常本金
    ,ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,next_term_repay_int_amt -- 下一期还息金额
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_repay_int_dt -- 下一期还息日期
    ,modif_post_repay_num_name -- 变更后还款账户名称
    ,modif_post_repay_num_id -- 变更后还款账户编号
    ,buy_out_liqd_flg -- 买断清收标志
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,wrtoff_dt -- 销账日期
    ,wrt_off_cate_cd -- 核销类别代码
    ,dubil_bal -- 借据余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,dubil_id -- 借据编号
    ,loan_type_cd -- 贷款类型代码
    ,surp_perds -- 剩余期数
    ,int_accr_way_cd -- 计息方式代码
    ,ped_cd -- 周期代码
    ,loan_kind_cd -- 贷款种类代码
    ,eh_issue_deduct_amt -- 每期扣款金额
    ,unpay_nomal_int -- 未结正常利息
    ,pre_recv_int_flg -- 收息标志
    ,ovdue_comp_int -- 逾期复利
    ,ovdue_int -- 逾期利息
    ,ovdue_pnlt -- 逾期罚息
    ,ovdue_nomal_pric -- 逾期正常本金
    ,ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,next_term_repay_int_amt -- 下一期还息金额
    ,next_term_rpp_amt -- 下一期还本金额
    ,next_term_rpp_dt -- 下一期还本日期
    ,next_term_repay_int_dt -- 下一期还息日期
    ,modif_post_repay_num_name -- 变更后还款账户名称
    ,modif_post_repay_num_id -- 变更后还款账户编号
    ,buy_out_liqd_flg -- 买断清收标志
    ,wrt_off_in_bs_int -- 核销表内利息
    ,wrt_off_off_bs_int -- 核销表外利息
    ,wrtoff_dt -- 销账日期
    ,wrt_off_cate_cd -- 核销类别代码
    ,dubil_bal -- 借据余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.dubil_id -- 借据编号
    ,o.loan_type_cd -- 贷款类型代码
    ,o.surp_perds -- 剩余期数
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.ped_cd -- 周期代码
    ,o.loan_kind_cd -- 贷款种类代码
    ,o.eh_issue_deduct_amt -- 每期扣款金额
    ,o.unpay_nomal_int -- 未结正常利息
    ,o.pre_recv_int_flg -- 收息标志
    ,o.ovdue_comp_int -- 逾期复利
    ,o.ovdue_int -- 逾期利息
    ,o.ovdue_pnlt -- 逾期罚息
    ,o.ovdue_nomal_pric -- 逾期正常本金
    ,o.ovdue_acm_rpbl_amt -- 逾期累计应还金额
    ,o.ovdue_mgmt_ovdue_pric -- 逾期管理逾期本金
    ,o.next_term_repay_int_amt -- 下一期还息金额
    ,o.next_term_rpp_amt -- 下一期还本金额
    ,o.next_term_rpp_dt -- 下一期还本日期
    ,o.next_term_repay_int_dt -- 下一期还息日期
    ,o.modif_post_repay_num_name -- 变更后还款账户名称
    ,o.modif_post_repay_num_id -- 变更后还款账户编号
    ,o.buy_out_liqd_flg -- 买断清收标志
    ,o.wrt_off_in_bs_int -- 核销表内利息
    ,o.wrt_off_off_bs_int -- 核销表外利息
    ,o.wrtoff_dt -- 销账日期
    ,o.wrt_off_cate_cd -- 核销类别代码
    ,o.dubil_bal -- 借据余额
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
from ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.dubil_id = n.dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.dubil_id = d.dubil_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h;
--alter table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_dubil_mini_loan_attach_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_dubil_mini_loan_attach_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
