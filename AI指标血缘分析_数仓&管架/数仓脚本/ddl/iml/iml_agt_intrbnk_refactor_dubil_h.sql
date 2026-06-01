/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_intrbnk_refactor_dubil_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_intrbnk_refactor_dubil_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_intrbnk_refactor_dubil_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intrbnk_refactor_dubil_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,id varchar2(100) -- ID
    ,intrbnk_refactor_id varchar2(100) -- 跨行再保理编号
    ,fin_appl_id varchar2(100) -- 融资申请编号
    ,dubil_id varchar2(100) -- 借据编号
    ,prod_id varchar2(100) -- 产品编号
    ,prod_name varchar2(500) -- 产品名称
    ,fin_amt number(30,8) -- 融资金额
    ,fin_start_dt date -- 融资开始日期
    ,fin_exp_dt date -- 融资到期日期
    ,effect_flg varchar2(10) -- 生效标志
    ,tran_net_price number(30,8) -- 转让净价
    ,sell_int number(30,8) -- 卖出利息
    ,sell_comm_fee number(30,8) -- 卖出手续费
    ,tran_cosdetn number(30,8) -- 转让对价
    ,tran_org_id varchar2(250) -- 转让机构编号
    ,cont_exp_dt date -- 合同到期日期
    ,sys_del_flg varchar2(10) -- 系统内删除标志
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
grant select on ${iml_schema}.agt_intrbnk_refactor_dubil_h to ${icl_schema};
grant select on ${iml_schema}.agt_intrbnk_refactor_dubil_h to ${idl_schema};
grant select on ${iml_schema}.agt_intrbnk_refactor_dubil_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_intrbnk_refactor_dubil_h is '跨行再保理借据信息历史';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.id is 'ID';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.intrbnk_refactor_id is '跨行再保理编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.fin_appl_id is '融资申请编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.dubil_id is '借据编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.prod_name is '产品名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.fin_amt is '融资金额';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.fin_start_dt is '融资开始日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.fin_exp_dt is '融资到期日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.effect_flg is '生效标志';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.tran_net_price is '转让净价';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.sell_int is '卖出利息';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.sell_comm_fee is '卖出手续费';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.tran_cosdetn is '转让对价';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.tran_org_id is '转让机构编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.cont_exp_dt is '合同到期日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.sys_del_flg is '系统内删除标志';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_intrbnk_refactor_dubil_h.etl_timestamp is 'ETL处理时间戳';
