/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_user_move_equip_para_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_user_move_equip_para_h
whenever sqlerror continue none;
drop table ${iml_schema}.ref_user_move_equip_para_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_user_move_equip_para_h(
    main_acct_id varchar2(100) -- 主账户编号
    ,lp_id varchar2(60) -- 法人编号
    ,main_acct_idf_id varchar2(100) -- 主账户标识编号
    ,move_termn_type_cd varchar2(30) -- 移动终端类型代码
    ,save_chip_idf_id varchar2(100) -- 安全芯片标识编号
    ,equip_card_no varchar2(100) -- 设备卡号
    ,equip_card_idf_id varchar2(100) -- 设备卡标识编号
    ,equip_card_status_cd varchar2(30) -- 设备卡状态代码
    ,oper_tm timestamp -- 操作时间
    ,cust_id varchar2(100) -- 客户编号
    ,card_holder_name varchar2(150) -- 持卡人姓名
    ,rsrv_mobile_no varchar2(100) -- 预留手机号码
    ,init_chn_cd varchar2(30) -- 发起渠道代码
    ,agt_claus_id varchar2(100) -- 协议条款编号
    ,claus_acpt_dt date -- 条款接受日期
    ,vp varchar2(150) -- 有效期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.ref_user_move_equip_para_h to ${icl_schema};
grant select on ${iml_schema}.ref_user_move_equip_para_h to ${idl_schema};
grant select on ${iml_schema}.ref_user_move_equip_para_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_user_move_equip_para_h is '用户移动设备参数历史';
comment on column ${iml_schema}.ref_user_move_equip_para_h.main_acct_id is '主账户编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.lp_id is '法人编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.main_acct_idf_id is '主账户标识编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.move_termn_type_cd is '移动终端类型代码';
comment on column ${iml_schema}.ref_user_move_equip_para_h.save_chip_idf_id is '安全芯片标识编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.equip_card_no is '设备卡号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.equip_card_idf_id is '设备卡标识编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.equip_card_status_cd is '设备卡状态代码';
comment on column ${iml_schema}.ref_user_move_equip_para_h.oper_tm is '操作时间';
comment on column ${iml_schema}.ref_user_move_equip_para_h.cust_id is '客户编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.card_holder_name is '持卡人姓名';
comment on column ${iml_schema}.ref_user_move_equip_para_h.rsrv_mobile_no is '预留手机号码';
comment on column ${iml_schema}.ref_user_move_equip_para_h.init_chn_cd is '发起渠道代码';
comment on column ${iml_schema}.ref_user_move_equip_para_h.agt_claus_id is '协议条款编号';
comment on column ${iml_schema}.ref_user_move_equip_para_h.claus_acpt_dt is '条款接受日期';
comment on column ${iml_schema}.ref_user_move_equip_para_h.vp is '有效期';
comment on column ${iml_schema}.ref_user_move_equip_para_h.start_dt is '开始时间';
comment on column ${iml_schema}.ref_user_move_equip_para_h.end_dt is '结束时间';
comment on column ${iml_schema}.ref_user_move_equip_para_h.id_mark is '增删标志';
comment on column ${iml_schema}.ref_user_move_equip_para_h.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_user_move_equip_para_h.job_cd is '任务编码';
comment on column ${iml_schema}.ref_user_move_equip_para_h.etl_timestamp is 'ETL处理时间戳';
