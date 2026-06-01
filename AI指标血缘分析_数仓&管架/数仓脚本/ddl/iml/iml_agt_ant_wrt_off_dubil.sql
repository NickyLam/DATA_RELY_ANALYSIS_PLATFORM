/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_ant_wrt_off_dubil
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_ant_wrt_off_dubil
whenever sqlerror continue none;
drop table ${iml_schema}.agt_ant_wrt_off_dubil purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ant_wrt_off_dubil(
    agt_id varchar2(60) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,dubil_id varchar2(60) -- 借据编号
    ,cust_id varchar2(60) -- 客户编号
    ,dubil_amt number(30,2) -- 借据金额
    ,curr_bal number(30,2) -- 当前余额
    ,exp_dt date -- 到期日期
    ,exec_int_rat number(18,8) -- 执行利率
    ,ovdue_days number(22) -- 贷款逾期天数
    ,int number(30,2) -- 利息
    ,pnlt number(30,2) -- 罚息
    ,repay_way_cd varchar2(10) -- 还款方式代码
    ,tenor number(10) -- 期限
    ,acct_instit_id varchar2(60) -- 账务机构编号
    ,wrt_off_status_cd varchar2(10) -- 核销状态代码
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,distr_dt date -- 放款日期
    ,ovdue_dt date -- 逾期日期
    ,coll_cnt number(10) -- 催收次数
    ,insto_dt date -- 入库日期
    ,fir_wrt_off_dt date -- 首次核销日期
    ,recvbl_pric number(30,2) -- 应收本金
    ,recvbl_off_bs_int number(30,2) -- 应收表外利息
    ,remark varchar2(500) -- 备注
    ,level5_cls_cd varchar2(10) -- 五级分类代码
    ,advc_fee number(30,2) -- 垫付费用
    ,cust_name varchar2(500) -- 客户名称
    ,gender_cd varchar2(30) -- 性别代码
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,insto_batch_no varchar2(100) -- 入库批次号
    ,dubil_type_cd varchar2(30) -- 借据类型代码
    ,loan_bal number(30) -- 贷款余额
    ,dep_bal number(30) -- 存款余额
    ,wrt_off_in_bs_int number(30) -- 核销表内利息
    ,final_update_dt date -- 最后更新日期
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
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
grant select on ${iml_schema}.agt_ant_wrt_off_dubil to ${icl_schema};
grant select on ${iml_schema}.agt_ant_wrt_off_dubil to ${idl_schema};
grant select on ${iml_schema}.agt_ant_wrt_off_dubil to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_ant_wrt_off_dubil is '蚂蚁核销借据';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.agt_id is '协议编号';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.lp_id is '法人编号';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.cust_id is '客户编号';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.dubil_amt is '借据金额';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.curr_bal is '当前余额';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.ovdue_days is '贷款逾期天数';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.int is '利息';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.pnlt is '罚息';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.repay_way_cd is '还款方式代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.tenor is '期限';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.acct_instit_id is '账务机构编号';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.wrt_off_status_cd is '核销状态代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.distr_dt is '放款日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.ovdue_dt is '逾期日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.coll_cnt is '催收次数';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.insto_dt is '入库日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.fir_wrt_off_dt is '首次核销日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.recvbl_pric is '应收本金';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.recvbl_off_bs_int is '应收表外利息';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.remark is '备注';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.level5_cls_cd is '五级分类代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.advc_fee is '垫付费用';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.cust_name is '客户名称';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.gender_cd is '性别代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.cert_no is '证件号码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.insto_batch_no is '入库批次号';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.dubil_type_cd is '借据类型代码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.loan_bal is '贷款余额';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.dep_bal is '存款余额';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.wrt_off_in_bs_int is '核销表内利息';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.final_update_dt is '最后更新日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.create_dt is '创建日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.update_dt is '更新日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.id_mark is '增删标志';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.job_cd is '任务编码';
comment on column ${iml_schema}.agt_ant_wrt_off_dubil.etl_timestamp is 'ETL处理时间戳';
