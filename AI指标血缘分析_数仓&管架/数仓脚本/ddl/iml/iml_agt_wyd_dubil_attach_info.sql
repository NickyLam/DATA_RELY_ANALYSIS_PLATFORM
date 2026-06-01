/*
Purpose:    整合模型层-切片建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_wyd_dubil_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_wyd_dubil_attach_info
whenever sqlerror continue none;
drop table ${iml_schema}.agt_wyd_dubil_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wyd_dubil_attach_info(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,cont_id varchar2(100) -- 合同编号
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,prod_id varchar2(100) -- 产品编号
    ,level5_cls_cd varchar2(30) -- 五级分类代码
    ,level11_cls_cd varchar2(30) -- 十一级分类代码
    ,loan_cate_cd varchar2(30) -- 贷款类别代码
    ,loan_type_cd varchar2(30) -- 贷款类型代码
    ,loan_num number(10) -- 总期数
    ,curr_perds number(10) -- 当前期数
    ,indus_subclass_cd varchar2(100) -- 行业细类代码
    ,repay_freq_cd varchar2(30) -- 还款频率代码
    ,guar_way_cd varchar2(30) -- 担保方式代码
    ,distr_mode_pay_cd varchar2(30) -- 放款支付方式代码
    ,next_int_rat_reval_day date -- 下一利率重定价日期
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,int_accr_flg varchar2(10) -- 计息标志
    ,int_recvbl number(30,8) -- 应收利息
    ,grace_period number(10) -- 宽限期
    ,ovdue_days number(10) -- 贷款逾期天数
    ,pric_ovdue_dt date -- 本金逾期日期
    ,ovdue_pric number(30,8) -- 逾期本金
    ,int_ovdue_dt date -- 利息逾期日期
    ,ovdue_int number(30,8) -- 逾期利息
    ,ovdue_tot_amt number(30,8) -- 逾期总金额
    ,regroup_loan_flg varchar2(10) -- 重组贷款标志
    ,regroup_dt date -- 重组日期
    ,revo_dt date -- 撤销日期
    ,payoff_dt date -- 结清日期
    ,wrt_off_dt date -- 核销日期
    ,proj_id varchar2(100) -- 项目编号
    ,rgst_teller_id varchar2(100) -- 登记柜员编号
    ,rgst_belong_org_id varchar2(100) -- 登记所属机构编号
    ,rgst_dt date -- 登记日期
    ,final_update_teller_id varchar2(100) -- 最后更新柜员编号
    ,final_update_org_id varchar2(100) -- 最后更新机构编号
    ,final_update_dt date -- 最后更新日期
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_wyd_dubil_attach_info to ${icl_schema};
grant select on ${iml_schema}.agt_wyd_dubil_attach_info to ${idl_schema};
grant select on ${iml_schema}.agt_wyd_dubil_attach_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_wyd_dubil_attach_info is '微业贷借据补充信息';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.agt_id is '协议编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.lp_id is '法人编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.cont_id is '合同编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.cust_id is '客户编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.cust_name is '客户名称';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.prod_id is '产品编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.level11_cls_cd is '十一级分类代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.loan_cate_cd is '贷款类别代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.loan_type_cd is '贷款类型代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.loan_num is '总期数';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.curr_perds is '当前期数';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.indus_subclass_cd is '行业细类代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.repay_freq_cd is '还款频率代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.guar_way_cd is '担保方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.distr_mode_pay_cd is '放款支付方式代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.next_int_rat_reval_day is '下一利率重定价日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.int_accr_flg is '计息标志';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.int_recvbl is '应收利息';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.grace_period is '宽限期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.pric_ovdue_dt is '本金逾期日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.ovdue_pric is '逾期本金';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.int_ovdue_dt is '利息逾期日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.ovdue_int is '逾期利息';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.ovdue_tot_amt is '逾期总金额';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.regroup_loan_flg is '重组贷款标志';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.regroup_dt is '重组日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.revo_dt is '撤销日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.payoff_dt is '结清日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.wrt_off_dt is '核销日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.proj_id is '项目编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.rgst_teller_id is '登记柜员编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.rgst_belong_org_id is '登记所属机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.rgst_dt is '登记日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.final_update_teller_id is '最后更新柜员编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.final_update_org_id is '最后更新机构编号';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.job_cd is '任务编码';
comment on column ${iml_schema}.agt_wyd_dubil_attach_info.etl_timestamp is 'ETL处理时间戳';
