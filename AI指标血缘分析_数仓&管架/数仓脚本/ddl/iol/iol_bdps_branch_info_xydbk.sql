/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_branch_info_xydbk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_branch_info_xydbk
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_branch_info_xydbk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_branch_info_xydbk(
    id number(22,0) -- id
    ,brh_no varchar2(20) -- 行号
    ,brh_name varchar2(180) -- 行名
    ,brh_class varchar2(1) -- 机构级别
    ,bln_up_brh_id number(22,0) -- 管辖机构
    ,tele_no varchar2(20) -- 联系电话
    ,address varchar2(180) -- 地址
    ,postno varchar2(10) -- 邮编
    ,status varchar2(1) -- 状态
    ,effect_date varchar2(8) -- 生效日期
    ,expire_date varchar2(8) -- 失效日期
    ,bln_brh_no number(22,0) -- 分行号
    ,ubank_no varchar2(12) -- 联行号
    ,acct_brh_id number(22,0) -- 记账机构id
    ,bop_financ_org_code varchar2(20) -- 人民银行金融机构编号
    ,last_upd_oper_id number(22,0) -- 最后修改操作员号
    ,last_upd_time varchar2(14) -- 最后修改时间
    ,dualcontrol_lockstatuscert varchar2(1) -- 双岗复核锁标记
    ,dualcontrol_lockstatus varchar2(1) -- 
    ,brcode varchar2(6) -- 支行号
    ,manager varchar2(60) -- 负责人
    ,misc varchar2(60) -- 备注
    ,brh_full_name varchar2(100) -- 机构全称
    ,belong_brh_id_opt number(22,0) -- 撤并机构id
    ,organcodekey varchar2(12) -- 机构唯一标识
    ,funorgan varchar2(12) -- 职能机构
    ,fundep varchar2(12) -- 职能部门
    ,financialcode varchar2(12) -- 金融机构标识码
    ,swiftcode varchar2(11) -- swift号码
    ,bankcode varchar2(12) -- 支付系统银行行号
    ,businesslicense varchar2(14) -- 营业执照号码
    ,organizationcode varchar2(9) -- 内部机构代码
    ,taxid varchar2(15) -- 税务登记证号
    ,organenfullname varchar2(100) -- 内部机构英文全称
    ,organenshortname varchar2(100) -- 内部机构英文简称
    ,organstatecode varchar2(1) -- 机构营业状态代码
    ,organtype varchar2(2) -- 内部机构类型代码
    ,isst varchar2(1) -- 实体机构标志
    ,ishs varchar2(1) -- 核算机构标志
    ,isyy varchar2(1) -- 营业机构标志
    ,isxz varchar2(1) -- 行政机构标志
    ,iszw varchar2(1) -- 账务机构标志
    ,leafnoteflag varchar2(1) -- 叶节点标志
    ,zwuporgancode varchar2(12) -- 账务上级内部机构编码
    ,hsuporgancode varchar2(12) -- 核算上级内部机构编码
    ,seque varchar2(3) -- 机构顺序号
    ,country varchar2(3) -- 所在国家
    ,province varchar2(6) -- 所在省/州
    ,city varchar2(6) -- 所在城市
    ,county varchar2(6) -- 所在县/区
    ,email varchar2(50) -- 电子邮箱
    ,url varchar2(50) -- 网址
    ,countrycode varchar2(4) -- 国际长途区号
    ,areacode varchar2(4) -- 国内长途区号
    ,subphone varchar2(6) -- 分机号
    ,servicephone varchar2(11) -- 服务电话
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
grant select on ${iol_schema}.bdps_branch_info_xydbk to ${iml_schema};
grant select on ${iol_schema}.bdps_branch_info_xydbk to ${icl_schema};
grant select on ${iol_schema}.bdps_branch_info_xydbk to ${idl_schema};
grant select on ${iol_schema}.bdps_branch_info_xydbk to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_branch_info_xydbk is '机构信息表';
comment on column ${iol_schema}.bdps_branch_info_xydbk.id is 'id';
comment on column ${iol_schema}.bdps_branch_info_xydbk.brh_no is '行号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.brh_name is '行名';
comment on column ${iol_schema}.bdps_branch_info_xydbk.brh_class is '机构级别';
comment on column ${iol_schema}.bdps_branch_info_xydbk.bln_up_brh_id is '管辖机构';
comment on column ${iol_schema}.bdps_branch_info_xydbk.tele_no is '联系电话';
comment on column ${iol_schema}.bdps_branch_info_xydbk.address is '地址';
comment on column ${iol_schema}.bdps_branch_info_xydbk.postno is '邮编';
comment on column ${iol_schema}.bdps_branch_info_xydbk.status is '状态';
comment on column ${iol_schema}.bdps_branch_info_xydbk.effect_date is '生效日期';
comment on column ${iol_schema}.bdps_branch_info_xydbk.expire_date is '失效日期';
comment on column ${iol_schema}.bdps_branch_info_xydbk.bln_brh_no is '分行号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.ubank_no is '联行号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.acct_brh_id is '记账机构id';
comment on column ${iol_schema}.bdps_branch_info_xydbk.bop_financ_org_code is '人民银行金融机构编号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.last_upd_oper_id is '最后修改操作员号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdps_branch_info_xydbk.dualcontrol_lockstatuscert is '双岗复核锁标记';
comment on column ${iol_schema}.bdps_branch_info_xydbk.dualcontrol_lockstatus is '';
comment on column ${iol_schema}.bdps_branch_info_xydbk.brcode is '支行号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.manager is '负责人';
comment on column ${iol_schema}.bdps_branch_info_xydbk.misc is '备注';
comment on column ${iol_schema}.bdps_branch_info_xydbk.brh_full_name is '机构全称';
comment on column ${iol_schema}.bdps_branch_info_xydbk.belong_brh_id_opt is '撤并机构id';
comment on column ${iol_schema}.bdps_branch_info_xydbk.organcodekey is '机构唯一标识';
comment on column ${iol_schema}.bdps_branch_info_xydbk.funorgan is '职能机构';
comment on column ${iol_schema}.bdps_branch_info_xydbk.fundep is '职能部门';
comment on column ${iol_schema}.bdps_branch_info_xydbk.financialcode is '金融机构标识码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.swiftcode is 'swift号码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.bankcode is '支付系统银行行号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.businesslicense is '营业执照号码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.organizationcode is '内部机构代码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.taxid is '税务登记证号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.organenfullname is '内部机构英文全称';
comment on column ${iol_schema}.bdps_branch_info_xydbk.organenshortname is '内部机构英文简称';
comment on column ${iol_schema}.bdps_branch_info_xydbk.organstatecode is '机构营业状态代码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.organtype is '内部机构类型代码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.isst is '实体机构标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.ishs is '核算机构标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.isyy is '营业机构标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.isxz is '行政机构标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.iszw is '账务机构标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.leafnoteflag is '叶节点标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.zwuporgancode is '账务上级内部机构编码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.hsuporgancode is '核算上级内部机构编码';
comment on column ${iol_schema}.bdps_branch_info_xydbk.seque is '机构顺序号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.country is '所在国家';
comment on column ${iol_schema}.bdps_branch_info_xydbk.province is '所在省/州';
comment on column ${iol_schema}.bdps_branch_info_xydbk.city is '所在城市';
comment on column ${iol_schema}.bdps_branch_info_xydbk.county is '所在县/区';
comment on column ${iol_schema}.bdps_branch_info_xydbk.email is '电子邮箱';
comment on column ${iol_schema}.bdps_branch_info_xydbk.url is '网址';
comment on column ${iol_schema}.bdps_branch_info_xydbk.countrycode is '国际长途区号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.areacode is '国内长途区号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.subphone is '分机号';
comment on column ${iol_schema}.bdps_branch_info_xydbk.servicephone is '服务电话';
comment on column ${iol_schema}.bdps_branch_info_xydbk.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_branch_info_xydbk.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_branch_info_xydbk.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_branch_info_xydbk.etl_timestamp is 'ETL处理时间戳';
