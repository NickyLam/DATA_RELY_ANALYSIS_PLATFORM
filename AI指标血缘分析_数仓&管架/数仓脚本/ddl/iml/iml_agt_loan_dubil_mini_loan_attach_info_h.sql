/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_loan_dubil_mini_loan_attach_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h(
    agt_id varchar2(250) -- 协议编号
    ,dubil_id varchar2(100) -- 借据编号
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,surp_perds number(10) -- 剩余期数
    ,int_accr_way_cd varchar2(30) -- 计息方式代码
    ,ped_cd varchar2(30) -- 周期代码
    ,loan_kind_cd varchar2(30) -- 贷款种类代码
    ,eh_issue_deduct_amt number(30,2) -- 每期扣款金额
    ,unpay_nomal_int number(30,2) -- 未结正常利息
    ,pre_recv_int_flg varchar2(10) -- 收息标志
    ,ovdue_comp_int number(30,2) -- 逾期复利
    ,ovdue_int number(30,2) -- 逾期利息
    ,ovdue_pnlt number(30,2) -- 逾期罚息
    ,ovdue_nomal_pric number(30,2) -- 逾期正常本金
    ,ovdue_acm_rpbl_amt number(30,2) -- 逾期累计应还金额
    ,ovdue_mgmt_ovdue_pric number(30,2) -- 逾期管理逾期本金
    ,next_term_repay_int_amt number(30,2) -- 下一期还息金额
    ,next_term_rpp_amt number(30,2) -- 下一期还本金额
    ,next_term_rpp_dt date -- 下一期还本日期
    ,next_term_repay_int_dt date -- 下一期还息日期
    ,modif_post_repay_num_name varchar2(500) -- 变更后还款账户名称
    ,modif_post_repay_num_id varchar2(100) -- 变更后还款账户编号
    ,buy_out_liqd_flg varchar2(10) -- 买断清收标志
    ,wrt_off_in_bs_int number(30,2) -- 核销表内利息
    ,wrt_off_off_bs_int number(30,2) -- 核销表外利息
    ,wrtoff_dt date -- 销账日期
    ,wrt_off_cate_cd varchar2(30) -- 核销类别代码
    ,dubil_bal number(30,8) -- 借据余额
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h is '贷款借据微贷附属信息历史';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.surp_perds is '剩余期数';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.int_accr_way_cd is '计息方式代码';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ped_cd is '周期代码';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.loan_kind_cd is '贷款种类代码';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.eh_issue_deduct_amt is '每期扣款金额';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.unpay_nomal_int is '未结正常利息';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.pre_recv_int_flg is '收息标志';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ovdue_comp_int is '逾期复利';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ovdue_int is '逾期利息';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ovdue_pnlt is '逾期罚息';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ovdue_nomal_pric is '逾期正常本金';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ovdue_acm_rpbl_amt is '逾期累计应还金额';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.ovdue_mgmt_ovdue_pric is '逾期管理逾期本金';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.next_term_repay_int_amt is '下一期还息金额';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.next_term_rpp_amt is '下一期还本金额';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.next_term_rpp_dt is '下一期还本日期';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.next_term_repay_int_dt is '下一期还息日期';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.modif_post_repay_num_name is '变更后还款账户名称';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.modif_post_repay_num_id is '变更后还款账户编号';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.buy_out_liqd_flg is '买断清收标志';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.wrt_off_in_bs_int is '核销表内利息';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.wrt_off_off_bs_int is '核销表外利息';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.wrtoff_dt is '销账日期';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.wrt_off_cate_cd is '核销类别代码';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.dubil_bal is '借据余额';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_loan_dubil_mini_loan_attach_info_h.etl_timestamp is 'ETL处理时间戳';
