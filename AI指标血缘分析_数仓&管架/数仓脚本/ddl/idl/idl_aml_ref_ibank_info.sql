/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ref_ibank_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ref_ibank_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ref_ibank_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ref_ibank_info(
    etl_dt date -- 数据日期   
    ,ibank_no varchar2(60) -- 联行号   
    ,lp_id varchar2(60) -- 法人编号   
    ,bank_cls_id varchar2(100) -- 行分类编号   
    ,super_prtcpt_bank_no varchar2(60) -- 上级参与行号   
    ,super_bank_list varchar2(250) -- 上级行列表   
    ,belong_bank_no varchar2(60) -- 所属人行号   
    ,prtcpt_type_cd varchar2(30) -- 参与类型代码   
    ,bank_type_cd varchar2(30) -- 行别代码   
    ,node_cd varchar2(30) -- 节点代码   
    ,rg_cd varchar2(30) -- 地区代码   
    ,status_cd varchar2(30) -- 状态代码   
    ,bank_fname varchar2(250) -- 银行全称   
    ,bank_abbr varchar2(100) -- 银行简称   
    ,phys_addr varchar2(250) -- 物理地址   
    ,zip_cd varchar2(60) -- 邮政编码   
    ,tel_num varchar2(250) -- 电话号码   
    ,elec_addr varchar2(250) -- 电子地址   
    ,effect_dt date -- 生效日期   
    ,invalid_dt date -- 失效日期   
    ,cert_bind_cn_region varchar2(500) -- 证书绑定CN域   
    ,cert_bind_sn_region varchar2(500) -- 证书绑定SN域   
    ,cert_bind_status varchar2(30) -- 证书绑定状态   
    ,cert_bind_effect_dt date -- 证书绑定生效日期   
    ,cert_bind_invalid_dt date -- 证书绑定失效日期   
    ,final_modif_operr_id varchar2(100) -- 最后修改操作员编号   
    ,final_update_tm timestamp -- 最后更新时间   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_ref_ibank_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ref_ibank_info is '联行信息';
comment on column ${idl_schema}.aml_ref_ibank_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_ref_ibank_info.ibank_no is '联行号';
comment on column ${idl_schema}.aml_ref_ibank_info.lp_id is '法人编号';
comment on column ${idl_schema}.aml_ref_ibank_info.bank_cls_id is '行分类编号';
comment on column ${idl_schema}.aml_ref_ibank_info.super_prtcpt_bank_no is '上级参与行号';
comment on column ${idl_schema}.aml_ref_ibank_info.super_bank_list is '上级行列表';
comment on column ${idl_schema}.aml_ref_ibank_info.belong_bank_no is '所属人行号';
comment on column ${idl_schema}.aml_ref_ibank_info.prtcpt_type_cd is '参与类型代码';
comment on column ${idl_schema}.aml_ref_ibank_info.bank_type_cd is '行别代码';
comment on column ${idl_schema}.aml_ref_ibank_info.node_cd is '节点代码';
comment on column ${idl_schema}.aml_ref_ibank_info.rg_cd is '地区代码';
comment on column ${idl_schema}.aml_ref_ibank_info.status_cd is '状态代码';
comment on column ${idl_schema}.aml_ref_ibank_info.bank_fname is '银行全称';
comment on column ${idl_schema}.aml_ref_ibank_info.bank_abbr is '银行简称';
comment on column ${idl_schema}.aml_ref_ibank_info.phys_addr is '物理地址';
comment on column ${idl_schema}.aml_ref_ibank_info.zip_cd is '邮政编码';
comment on column ${idl_schema}.aml_ref_ibank_info.tel_num is '电话号码';
comment on column ${idl_schema}.aml_ref_ibank_info.elec_addr is '电子地址';
comment on column ${idl_schema}.aml_ref_ibank_info.effect_dt is '生效日期';
comment on column ${idl_schema}.aml_ref_ibank_info.invalid_dt is '失效日期';
comment on column ${idl_schema}.aml_ref_ibank_info.cert_bind_cn_region is '证书绑定CN域';
comment on column ${idl_schema}.aml_ref_ibank_info.cert_bind_sn_region is '证书绑定SN域';
comment on column ${idl_schema}.aml_ref_ibank_info.cert_bind_status is '证书绑定状态';
comment on column ${idl_schema}.aml_ref_ibank_info.cert_bind_effect_dt is '证书绑定生效日期';
comment on column ${idl_schema}.aml_ref_ibank_info.cert_bind_invalid_dt is '证书绑定失效日期';
comment on column ${idl_schema}.aml_ref_ibank_info.final_modif_operr_id is '最后修改操作员编号';
comment on column ${idl_schema}.aml_ref_ibank_info.final_update_tm is '最后更新时间';
comment on column ${idl_schema}.aml_ref_ibank_info.create_dt is '创建日期';
comment on column ${idl_schema}.aml_ref_ibank_info.update_dt is '更新日期';
comment on column ${idl_schema}.aml_ref_ibank_info.id_mark is '删除标识';
comment on column ${idl_schema}.aml_ref_ibank_info.job_cd is '任务代码';
comment on column ${idl_schema}.aml_ref_ibank_info.etl_timestamp is '数据处理时间';