/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_m_pf_ln_ftp_m
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_m_pf_ln_ftp_m
whenever sqlerror continue none;
drop table ${iol_schema}.pams_m_pf_ln_ftp_m purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_m_pf_ln_ftp_m(
    date_id varchar2(8) -- 数据日期
    ,lncf_no varchar2(40) -- 借据号
    ,cust_nm varchar2(100) -- 客户名称
    ,cust_no varchar2(20) -- 客户号
    ,brch_no varchar2(10) -- 机构号
    ,brch_nm varchar2(100) -- 机构名
    ,acc_code varchar2(20) -- 科目号
    ,acc_name varchar2(120) -- 科目名
    ,loan_tp varchar2(20) -- 贷款类型
    ,term_cd varchar2(6) -- 期限
    ,lncf_st varchar2(1) -- 借据状态
    ,cntr_ir number(11,7) -- 当前执行利率
    ,lncf_rt number(11,7) -- 基准利率
    ,nmfl_rt number(11,7) -- 利率浮动比率
    ,open_dt varchar2(8) -- 起息日
    ,clos_dt varchar2(8) -- 开始日
    ,crcy_cd varchar2(4) -- 币种
    ,day1 number(20,2) -- 1日
    ,day2 number(20,2) -- 2日
    ,day3 number(20,2) -- 3日
    ,day4 number(20,2) -- 4日
    ,day5 number(20,2) -- 5日
    ,day6 number(20,2) -- 6日
    ,day7 number(20,2) -- 7日
    ,day8 number(20,2) -- 8日
    ,day9 number(20,2) -- 9日
    ,day10 number(20,2) -- 10日
    ,day11 number(20,2) -- 11日
    ,day12 number(20,2) -- 12日
    ,day13 number(20,2) -- 13日
    ,day14 number(20,2) -- 14日
    ,day15 number(20,2) -- 15日
    ,day16 number(20,2) -- 16日
    ,day17 number(20,2) -- 17日
    ,day18 number(20,2) -- 18日
    ,day19 number(20,2) -- 19日
    ,day20 number(20,2) -- 20日
    ,day21 number(20,2) -- 21日
    ,day22 number(20,2) -- 22日
    ,day23 number(20,2) -- 23日
    ,day24 number(20,2) -- 24日
    ,day25 number(20,2) -- 25日
    ,day26 number(20,2) -- 26日
    ,day27 number(20,2) -- 27日
    ,day28 number(20,2) -- 28日
    ,day29 number(20,2) -- 29日
    ,day30 number(20,2) -- 30日
    ,day31 number(20,2) -- 31日
    ,ln_bal number(20,2) -- 当日余额
    ,loan_bal_mavg number(20,2) -- 月日均
    ,loan_bal_yavg number(38,2) -- 年日均
    ,curtam_month number(20,2) -- 月利息
    ,curtam_year number(38,2) -- 年利息
    ,ftp_rate number(20,6) -- FTP价格
    ,ftp_accint_month number(20,6) -- 当月FTP转移成本
    ,ftp_curtam_month number(20,6) -- 当月FTP净收益
    ,ftp_curtam_year number(38,6) -- 累计FTP净收益
    ,data_src_cd varchar2(4) -- 数据来源
    ,loan_bal_ycml number(20,2) -- 
    ,ftp_accint_year number(20,6) -- 累计FTP转移成本
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pams_m_pf_ln_ftp_m to ${iml_schema};
grant select on ${iol_schema}.pams_m_pf_ln_ftp_m to ${icl_schema};
grant select on ${iol_schema}.pams_m_pf_ln_ftp_m to ${idl_schema};
grant select on ${iol_schema}.pams_m_pf_ln_ftp_m to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_m_pf_ln_ftp_m is '贷款FTP明细表';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.date_id is '数据日期';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.lncf_no is '借据号';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.cust_nm is '客户名称';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.cust_no is '客户号';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.brch_no is '机构号';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.brch_nm is '机构名';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.acc_code is '科目号';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.acc_name is '科目名';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.loan_tp is '贷款类型';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.term_cd is '期限';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.lncf_st is '借据状态';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.cntr_ir is '当前执行利率';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.lncf_rt is '基准利率';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.nmfl_rt is '利率浮动比率';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.open_dt is '起息日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.clos_dt is '开始日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.crcy_cd is '币种';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day1 is '1日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day2 is '2日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day3 is '3日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day4 is '4日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day5 is '5日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day6 is '6日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day7 is '7日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day8 is '8日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day9 is '9日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day10 is '10日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day11 is '11日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day12 is '12日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day13 is '13日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day14 is '14日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day15 is '15日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day16 is '16日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day17 is '17日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day18 is '18日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day19 is '19日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day20 is '20日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day21 is '21日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day22 is '22日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day23 is '23日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day24 is '24日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day25 is '25日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day26 is '26日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day27 is '27日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day28 is '28日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day29 is '29日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day30 is '30日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.day31 is '31日';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.ln_bal is '当日余额';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.loan_bal_mavg is '月日均';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.loan_bal_yavg is '年日均';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.curtam_month is '月利息';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.curtam_year is '年利息';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.ftp_rate is 'FTP价格';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.ftp_accint_month is '当月FTP转移成本';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.ftp_curtam_month is '当月FTP净收益';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.ftp_curtam_year is '累计FTP净收益';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.data_src_cd is '数据来源';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.loan_bal_ycml is '';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.ftp_accint_year is '累计FTP转移成本';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_m_pf_ln_ftp_m.etl_timestamp is 'ETL处理时间戳';
