/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_pay_sys_org_info_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_pay_sys_org_info_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_pay_sys_org_info_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_pay_sys_org_info_para(
    pay_sys_org_info_id varchar2(60) -- 支付系统机构信息编号
    ,lp_id varchar2(60) -- 法人编号
    ,prtcpt_org_bank_no varchar2(60) -- 参与机构行号
    ,prtcpt_org_cate_cd varchar2(10) -- 参与机构类别代码
    ,bank_type_cd varchar2(10) -- 行别代码
    ,belong_dir_bk_num varchar2(60) -- 所属直参行号
    ,belong_lp_id varchar2(60) -- 所属法人编号
    ,super_prtcpt_org_id varchar2(250) -- 上级参与机构编号
    ,udtake_bank_no varchar2(60) -- 承接行行号
    ,durdt_bank_no varchar2(60) -- 管辖人行行号
    ,belong_pay_sys_cd varchar2(10) -- 所属支付系统代码
    ,city_cd varchar2(10) -- 所在城市代码
    ,prtcpt_org_cn_name varchar2(375) -- 参与机构中文名称
    ,tel_num_or_cable_addr varchar2(500) -- 电话号码或电挂
    ,pbc_bigamt_bus_sys_flg varchar2(10) -- 加入人行大额业务系统标志
    ,effect_type_cd varchar2(10) -- 生效类型代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
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
grant select on ${iml_schema}.ref_pay_sys_org_info_para to ${icl_schema};
grant select on ${iml_schema}.ref_pay_sys_org_info_para to ${idl_schema};
grant select on ${iml_schema}.ref_pay_sys_org_info_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_pay_sys_org_info_para is '支付系统机构信息参数';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.pay_sys_org_info_id is '支付系统机构信息编号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.prtcpt_org_bank_no is '参与机构行号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.prtcpt_org_cate_cd is '参与机构类别代码';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.bank_type_cd is '行别代码';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.belong_dir_bk_num is '所属直参行号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.belong_lp_id is '所属法人编号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.super_prtcpt_org_id is '上级参与机构编号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.udtake_bank_no is '承接行行号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.durdt_bank_no is '管辖人行行号';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.belong_pay_sys_cd is '所属支付系统代码';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.city_cd is '所在城市代码';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.prtcpt_org_cn_name is '参与机构中文名称';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.tel_num_or_cable_addr is '电话号码或电挂';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.pbc_bigamt_bus_sys_flg is '加入人行大额业务系统标志';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.effect_type_cd is '生效类型代码';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.effect_dt is '生效日期';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.invalid_dt is '失效日期';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_pay_sys_org_info_para.etl_timestamp is 'ETL处理时间戳';
