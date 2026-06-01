/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_jh_mcht_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_jh_mcht_inf
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_jh_mcht_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jh_mcht_inf(
    agent_cd varchar2(23) -- 代理编号
    ,mcht_no varchar2(23) -- 商户号
    ,mcht_nm varchar2(225) -- 商户名称
    ,mcht_cn_abbr varchar2(90) -- 中文名称简写
    ,spell_name varchar2(45) -- 商户拼音缩写
    ,eng_name varchar2(90) -- 商户英文名称
    ,mcht_en_abbr varchar2(30) -- 商户英文名称缩写
    ,license_type varchar2(48) -- 证件类型
    ,licence_no varchar2(30) -- 证件编号号码
    ,licence_end_date varchar2(12) -- 证件有效期
    ,mcht_lvl varchar2(2) -- 商户级别
    ,contact varchar2(45) -- 联系人姓名
    ,contact_class varchar2(45) -- 联系人类型
    ,comm_email varchar2(60) -- 联系人电子邮箱
    ,comm_mobil varchar2(30) -- 客户电话
    ,comm_tel varchar2(30) -- 联系人电话
    ,addr varchar2(579) -- 联系人地址
    ,manager varchar2(75) -- 法人姓名
    ,artif_certif_tp varchar2(30) -- 法人证件类型
    ,identity_no varchar2(30) -- 联系人证件号码
    ,manager_tel varchar2(18) -- 法人联系电话
    ,post_code varchar2(9) -- 邮编
    ,fax varchar2(30) -- 传真
    ,area_no varchar2(9) -- 区域代码
    ,mcht_eng_city_name varchar2(90) -- 商户所在城市
    ,mcht_key varchar2(48) -- 商户密钥
    ,oper_no varchar2(12) -- 客户经理工号
    ,oper_nm varchar2(15) -- 客户经理姓名
    ,mcht_status varchar2(15) -- 商户状态
    ,risl_lvl varchar2(2) -- 商户风险级别
    ,reg_addr varchar2(90) -- 注册地址
    ,bank_licence_no varchar2(30) -- 机构代码证号码
    ,bus_type varchar2(6) -- 营业性质
    ,fax_no varchar2(30) -- 税务登记证号码
    ,bus_amt varchar2(18) -- 注册资金
    ,mcht_cre_lvl varchar2(6) -- 企业资质等级
    ,apply_date varchar2(12) -- 申请日期
    ,enable_date varchar2(12) -- 启用日期
    ,pre_aud_nm varchar2(60) -- 初审人
    ,confirm_nm varchar2(60) -- 批准人
    ,protocal_id varchar2(30) -- 协议编号
    ,sign_inst_id varchar2(20) -- 签约机构代码(银联分配机构号)
    ,net_nm varchar2(45) -- 隶属网点代码
    ,agr_br varchar2(9) -- 签约网点
    ,net_tel varchar2(27) -- 网点电话
    ,prol_date varchar2(12) -- 签约日期
    ,prol_tlr varchar2(12) -- 签约柜员
    ,close_date varchar2(12) -- 撤消签约日期
    ,close_tlr varchar2(11) -- 撤消签约柜员
    ,main_tlr varchar2(12) -- 维护柜员
    ,check_tlr varchar2(12) -- 复核柜员
    ,acq_inst_id varchar2(20) -- 商户所属机构代码
    ,acq_bk_name varchar2(45) -- 收单行名称
    ,bank_no varchar2(9) -- 分行号
    ,mcht_secret varchar2(48) -- 商户秘钥
    ,reserved varchar2(90) -- 保留
    ,upd_opr_id varchar2(60) -- 修改记录操作员
    ,crt_opr_id varchar2(60) -- 创建记录操作员
    ,rec_upd_ts varchar2(21) -- 记录修改时间
    ,rec_crt_ts varchar2(21) -- 记录创建时间
    ,province_code varchar2(30) -- 省份编码
    ,city_code varchar2(30) -- 城市编码
    ,district_code varchar2(30) -- 区域编码
    ,legal_person_id_card varchar2(30) -- 法人证件号码
    ,flow_bank_no varchar2(45) -- 流程银行流水号
    ,flow_bank_status varchar2(2) -- 流程银行审批结果,0-初始状态1-审批通过2-审批不通过
    ,flow_bank_reserved varchar2(384) -- 流程银行审批描述
    ,h5_flow_flag varchar2(2) -- h5标识 ，1-h5渠道
    ,risk_statu varchar2(2) -- 
    ,mq_statu varchar2(2) -- 
    ,risk_describe varchar2(768) -- 
    ,risk_flag varchar2(99) -- 
    ,out_mcht_no varchar2(48) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_jh_mcht_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_jh_mcht_inf is '聚合商户表';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.agent_cd is '代理编号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_no is '商户号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_nm is '商户名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_cn_abbr is '中文名称简写';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.spell_name is '商户拼音缩写';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.eng_name is '商户英文名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_en_abbr is '商户英文名称缩写';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.license_type is '证件类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.licence_no is '证件编号号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.licence_end_date is '证件有效期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_lvl is '商户级别';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.contact is '联系人姓名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.contact_class is '联系人类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.comm_email is '联系人电子邮箱';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.comm_mobil is '客户电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.comm_tel is '联系人电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.addr is '联系人地址';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.manager is '法人姓名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.artif_certif_tp is '法人证件类型';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.identity_no is '联系人证件号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.manager_tel is '法人联系电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.post_code is '邮编';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.fax is '传真';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.area_no is '区域代码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_eng_city_name is '商户所在城市';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_key is '商户密钥';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.oper_no is '客户经理工号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.oper_nm is '客户经理姓名';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_status is '商户状态';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.risl_lvl is '商户风险级别';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.reg_addr is '注册地址';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.bank_licence_no is '机构代码证号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.bus_type is '营业性质';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.fax_no is '税务登记证号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.bus_amt is '注册资金';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_cre_lvl is '企业资质等级';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.apply_date is '申请日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.enable_date is '启用日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.pre_aud_nm is '初审人';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.confirm_nm is '批准人';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.protocal_id is '协议编号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.sign_inst_id is '签约机构代码(银联分配机构号)';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.net_nm is '隶属网点代码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.agr_br is '签约网点';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.net_tel is '网点电话';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.prol_date is '签约日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.prol_tlr is '签约柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.close_date is '撤消签约日期';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.close_tlr is '撤消签约柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.main_tlr is '维护柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.check_tlr is '复核柜员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.acq_inst_id is '商户所属机构代码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.acq_bk_name is '收单行名称';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.bank_no is '分行号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mcht_secret is '商户秘钥';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.reserved is '保留';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.upd_opr_id is '修改记录操作员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.crt_opr_id is '创建记录操作员';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.rec_upd_ts is '记录修改时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.rec_crt_ts is '记录创建时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.province_code is '省份编码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.city_code is '城市编码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.district_code is '区域编码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.legal_person_id_card is '法人证件号码';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.flow_bank_no is '流程银行流水号';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.flow_bank_status is '流程银行审批结果,0-初始状态1-审批通过2-审批不通过';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.flow_bank_reserved is '流程银行审批描述';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.h5_flow_flag is 'h5标识 ，1-h5渠道';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.risk_statu is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.mq_statu is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.risk_describe is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.risk_flag is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.out_mcht_no is '';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_jh_mcht_inf.etl_timestamp is 'ETL处理时间戳';
