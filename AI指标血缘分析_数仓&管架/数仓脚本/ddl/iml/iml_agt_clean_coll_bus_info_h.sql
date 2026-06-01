/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_clean_coll_bus_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_clean_coll_bus_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_clean_coll_bus_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_clean_coll_bus_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,clean_coll_bus_id varchar2(100) -- 光票托收业务编号
    ,bus_id varchar2(100) -- 业务编号
    ,tran_name varchar2(750) -- 交易名称
    ,draw_dt date -- 出票日期
    ,create_date date -- 创建日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,recvbl_dt date -- 收款日期
    ,dsply_info_flg varchar2(10) -- 显示信息标志
    ,clean_coll_form_cd varchar2(30) -- 光票托收形式代码
    ,pay_way_cd varchar2(30) -- 付款方式代码
    ,stl_way_cd varchar2(30) -- 结算方式代码
    ,bill_type_cd varchar2(30) -- 票据类型代码
    ,vrfction_slip_id varchar2(100) -- 核销单编号
    ,decl_form_id varchar2(100) -- 申报单编号
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,free_pay_flg varchar2(10) -- 自由付款标志
    ,nra_pay_flg varchar2(10) -- NRA付款标志
    ,pkg_coll_bus_id varchar2(100) -- 打包托收业务编号
    ,pkg_coll_recvbl_dt date -- 打包托收收款日期
    ,oper_teller_id varchar2(100) -- 经办柜员编号
    ,bus_oper_org_id varchar2(100) -- 业务经办机构编号
    ,bus_belong_org_id varchar2(100) -- 业务所属机构编号
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
grant select on ${iml_schema}.agt_clean_coll_bus_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_clean_coll_bus_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_clean_coll_bus_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_clean_coll_bus_info_h is '光票托收业务信息历史';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.clean_coll_bus_id is '光票托收业务编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.bus_id is '业务编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.tran_name is '交易名称';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.draw_dt is '出票日期';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.create_date is '创建日期';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.recvbl_dt is '收款日期';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.dsply_info_flg is '显示信息标志';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.clean_coll_form_cd is '光票托收形式代码';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.pay_way_cd is '付款方式代码';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.stl_way_cd is '结算方式代码';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.bill_type_cd is '票据类型代码';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.vrfction_slip_id is '核销单编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.decl_form_id is '申报单编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.free_pay_flg is '自由付款标志';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.nra_pay_flg is 'NRA付款标志';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.pkg_coll_bus_id is '打包托收业务编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.pkg_coll_recvbl_dt is '打包托收收款日期';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.oper_teller_id is '经办柜员编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.bus_oper_org_id is '业务经办机构编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.bus_belong_org_id is '业务所属机构编号';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_clean_coll_bus_info_h.etl_timestamp is 'ETL处理时间戳';
