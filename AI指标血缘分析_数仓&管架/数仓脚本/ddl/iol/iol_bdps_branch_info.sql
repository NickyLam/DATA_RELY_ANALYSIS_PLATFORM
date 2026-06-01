/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_branch_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_branch_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_branch_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_branch_info(
    id number(22,0) -- id
    ,brh_no varchar2(30) -- 行号
    ,brh_name varchar2(270) -- 行名
    ,brh_class varchar2(2) -- 机构级别
    ,bln_up_brh_id varchar2(18) -- 管辖机构
    ,tele_no varchar2(30) -- 联系电话
    ,address varchar2(600) -- 地址
    ,postno varchar2(15) -- 邮编
    ,status varchar2(2) -- 状态
    ,effect_date varchar2(12) -- 生效日期
    ,expire_date varchar2(12) -- 失效日期
    ,bln_brh_no number(22,0) -- 分行号
    ,ubank_no varchar2(18) -- 联行号
    ,acct_brh_id number(22,0) -- 记账机构id
    ,bop_financ_org_code varchar2(30) -- 人民银行金融机构编号
    ,last_upd_oper_id number(22,0) -- 最后修改操作员号
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,dualcontrol_lockstatuscert varchar2(2) -- 双岗复核锁标记
    ,dualcontrol_lockstatus varchar2(2) -- 
    ,brcode varchar2(9) -- 支行号
    ,manager varchar2(90) -- 负责人
    ,misc varchar2(90) -- 备注
    ,brh_full_name varchar2(300) -- 机构全称
    ,belong_brh_id_opt number(22,0) -- 撤并机构id
    ,organcodekey varchar2(18) -- 机构唯一标识
    ,funorgan varchar2(18) -- 职能机构
    ,fundep varchar2(18) -- 职能部门
    ,financialcode varchar2(18) -- 金融机构标识码
    ,swiftcode varchar2(45) -- swift号码
    ,bankcode varchar2(18) -- 支付系统银行行号
    ,businesslicense varchar2(45) -- 营业执照号码
    ,organizationcode varchar2(14) -- 内部机构代码
    ,taxid varchar2(23) -- 税务登记证号
    ,organenfullname varchar2(150) -- 内部机构英文全称
    ,organenshortname varchar2(150) -- 内部机构英文简称
    ,organstatecode varchar2(2) -- 机构营业状态代码
    ,organtype varchar2(3) -- 内部机构类型代码
    ,isst varchar2(2) -- 实体机构标志
    ,ishs varchar2(2) -- 核算机构标志
    ,isyy varchar2(2) -- 营业机构标志
    ,isxz varchar2(2) -- 行政机构标志
    ,iszw varchar2(2) -- 账务机构标志
    ,leafnoteflag varchar2(2) -- 叶节点标志
    ,zwuporgancode varchar2(18) -- 账务上级内部机构编码
    ,hsuporgancode varchar2(18) -- 核算上级内部机构编码
    ,seque varchar2(5) -- 机构顺序号
    ,country varchar2(5) -- 所在国家
    ,province varchar2(9) -- 所在省/州
    ,city varchar2(9) -- 所在城市
    ,county varchar2(9) -- 所在县/区
    ,email varchar2(75) -- 电子邮箱
    ,url varchar2(75) -- 网址
    ,countrycode varchar2(6) -- 国际长途区号
    ,areacode varchar2(6) -- 国内长途区号
    ,subphone varchar2(9) -- 分机号
    ,servicephone varchar2(30) -- 服务电话
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
grant select on ${iol_schema}.bdps_branch_info to ${iml_schema};
grant select on ${iol_schema}.bdps_branch_info to ${icl_schema};
grant select on ${iol_schema}.bdps_branch_info to ${idl_schema};
grant select on ${iol_schema}.bdps_branch_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_branch_info is '机构信息表';
comment on column ${iol_schema}.bdps_branch_info.id is 'id';
comment on column ${iol_schema}.bdps_branch_info.brh_no is '行号';
comment on column ${iol_schema}.bdps_branch_info.brh_name is '行名';
comment on column ${iol_schema}.bdps_branch_info.brh_class is '机构级别';
comment on column ${iol_schema}.bdps_branch_info.bln_up_brh_id is '管辖机构';
comment on column ${iol_schema}.bdps_branch_info.tele_no is '联系电话';
comment on column ${iol_schema}.bdps_branch_info.address is '地址';
comment on column ${iol_schema}.bdps_branch_info.postno is '邮编';
comment on column ${iol_schema}.bdps_branch_info.status is '状态';
comment on column ${iol_schema}.bdps_branch_info.effect_date is '生效日期';
comment on column ${iol_schema}.bdps_branch_info.expire_date is '失效日期';
comment on column ${iol_schema}.bdps_branch_info.bln_brh_no is '分行号';
comment on column ${iol_schema}.bdps_branch_info.ubank_no is '联行号';
comment on column ${iol_schema}.bdps_branch_info.acct_brh_id is '记账机构id';
comment on column ${iol_schema}.bdps_branch_info.bop_financ_org_code is '人民银行金融机构编号';
comment on column ${iol_schema}.bdps_branch_info.last_upd_oper_id is '最后修改操作员号';
comment on column ${iol_schema}.bdps_branch_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdps_branch_info.dualcontrol_lockstatuscert is '双岗复核锁标记';
comment on column ${iol_schema}.bdps_branch_info.dualcontrol_lockstatus is '';
comment on column ${iol_schema}.bdps_branch_info.brcode is '支行号';
comment on column ${iol_schema}.bdps_branch_info.manager is '负责人';
comment on column ${iol_schema}.bdps_branch_info.misc is '备注';
comment on column ${iol_schema}.bdps_branch_info.brh_full_name is '机构全称';
comment on column ${iol_schema}.bdps_branch_info.belong_brh_id_opt is '撤并机构id';
comment on column ${iol_schema}.bdps_branch_info.organcodekey is '机构唯一标识';
comment on column ${iol_schema}.bdps_branch_info.funorgan is '职能机构';
comment on column ${iol_schema}.bdps_branch_info.fundep is '职能部门';
comment on column ${iol_schema}.bdps_branch_info.financialcode is '金融机构标识码';
comment on column ${iol_schema}.bdps_branch_info.swiftcode is 'swift号码';
comment on column ${iol_schema}.bdps_branch_info.bankcode is '支付系统银行行号';
comment on column ${iol_schema}.bdps_branch_info.businesslicense is '营业执照号码';
comment on column ${iol_schema}.bdps_branch_info.organizationcode is '内部机构代码';
comment on column ${iol_schema}.bdps_branch_info.taxid is '税务登记证号';
comment on column ${iol_schema}.bdps_branch_info.organenfullname is '内部机构英文全称';
comment on column ${iol_schema}.bdps_branch_info.organenshortname is '内部机构英文简称';
comment on column ${iol_schema}.bdps_branch_info.organstatecode is '机构营业状态代码';
comment on column ${iol_schema}.bdps_branch_info.organtype is '内部机构类型代码';
comment on column ${iol_schema}.bdps_branch_info.isst is '实体机构标志';
comment on column ${iol_schema}.bdps_branch_info.ishs is '核算机构标志';
comment on column ${iol_schema}.bdps_branch_info.isyy is '营业机构标志';
comment on column ${iol_schema}.bdps_branch_info.isxz is '行政机构标志';
comment on column ${iol_schema}.bdps_branch_info.iszw is '账务机构标志';
comment on column ${iol_schema}.bdps_branch_info.leafnoteflag is '叶节点标志';
comment on column ${iol_schema}.bdps_branch_info.zwuporgancode is '账务上级内部机构编码';
comment on column ${iol_schema}.bdps_branch_info.hsuporgancode is '核算上级内部机构编码';
comment on column ${iol_schema}.bdps_branch_info.seque is '机构顺序号';
comment on column ${iol_schema}.bdps_branch_info.country is '所在国家';
comment on column ${iol_schema}.bdps_branch_info.province is '所在省/州';
comment on column ${iol_schema}.bdps_branch_info.city is '所在城市';
comment on column ${iol_schema}.bdps_branch_info.county is '所在县/区';
comment on column ${iol_schema}.bdps_branch_info.email is '电子邮箱';
comment on column ${iol_schema}.bdps_branch_info.url is '网址';
comment on column ${iol_schema}.bdps_branch_info.countrycode is '国际长途区号';
comment on column ${iol_schema}.bdps_branch_info.areacode is '国内长途区号';
comment on column ${iol_schema}.bdps_branch_info.subphone is '分机号';
comment on column ${iol_schema}.bdps_branch_info.servicephone is '服务电话';
comment on column ${iol_schema}.bdps_branch_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_branch_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_branch_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_branch_info.etl_timestamp is 'ETL处理时间戳';
