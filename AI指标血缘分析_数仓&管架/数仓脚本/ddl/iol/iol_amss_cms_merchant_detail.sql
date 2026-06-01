/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_merchant_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_merchant_detail
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_merchant_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_merchant_detail(
    merchant_detail_id varchar2(32) -- 商户详细信息ID.使用 商户编号 做商户详细信息的ID
    ,merchant_short_name varchar2(128) -- 商户简称.
    ,industr_id number(10,0) -- 行业类别.关联行业类别表
    ,province varchar2(64) -- 省份.
    ,city varchar2(64) -- 城市.
    ,county varchar2(64) -- 区/县.
    ,address varchar2(256) -- 地址.
    ,tel varchar2(128) -- 电话.
    ,email varchar2(64) -- 邮箱.
    ,web_site varchar2(128) -- 网址.
    ,principal varchar2(64) -- 负责人.
    ,id_code varchar2(128) -- 负责人身份证.
    ,principal_mobile varchar2(128) -- 负责人手机.
    ,customer_phone varchar2(128) -- 客服电话.
    ,fax varchar2(256) -- 传真.
    ,license_photo varchar2(300) -- 营业执照.
    ,indentity_photo varchar2(1000) -- 身份证照片.
    ,protocol_photo varchar2(1024) -- 商户协议照片.
    ,org_photo varchar2(1024) -- 组织机构代码证照片.
    ,other_doc varchar2(2000) -- 其他资料.资料包，以zip和rar格式上传和下载
    ,physics_flag number(4,0) -- 物理标识.1:正常;2:删除
    ,data_source number(4,0) -- 数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
    ,remark varchar2(256) -- 备注.
    ,fld_s1 varchar2(1024) -- 门头照路径
    ,fld_s2 varchar2(256) -- 营业执照注册号/统一社会信用代码图片路径
    ,fld_s3 varchar2(1024) -- 营业场所照片路径
    ,fld_n1 number(10,0) -- 性别
    ,fld_n2 number(10,0) -- (subjectType)商户主体类型
    ,fld_n3 number(10,0) -- 数值型保留字段3.
    ,fld_d1 timestamp -- 日期型保留字段1.
    ,create_user number(10,0) -- 创建用户.
    ,create_emp varchar2(32) -- 创建人.
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,interface_refund_audit number(4,0) -- 接口退款审核
    ,id_code_type number(10,0) -- 证件类型
    ,business_license_name varchar2(128) -- 营业执照名称
    ,account_code_photo varchar2(1000) -- 银行卡/开户许可证图片路径
    ,fld_n4 number(10,0) -- (fixedPlace)小微商户是否有固定经营场所
    ,fld_n5 number(20,0) -- 注册资本金
    ,fld_n6 number(10,0) -- 
    ,fld_n7 number(10,0) -- 
    ,fld_n8 number(10,0) -- 
    ,fld_s4 varchar2(512) -- (alipayAccount)保存支付宝账号
    ,fld_s5 varchar2(512) -- (contacts)保存联系人
    ,fld_s6 varchar2(3072) -- (businessScope)经营范围
    ,fld_s7 varchar2(512) -- (actualBusinessAddress)实际经营地址
    ,fld_s8 varchar2(512) -- (registeredAddress)注册地址
    ,id_code_expire timestamp -- 身份证到期日.
    ,business_license_expire timestamp -- 营业执照到期日.
    ,lcaddress varchar2(512) -- 商户定位地址
    ,questionnaire varchar2(1024) -- 调查表
    ,approval_form varchar2(1024) -- 审批表
    ,thi_doc_id varchar2(256) -- 第三方文档ID
    ,nationality_num varchar2(32) -- 国籍编号
    ,principal_profession varchar2(192) -- 负责人职业
    ,id_code_begin_time timestamp -- 证件有效期开始时间
    ,business_license_begin_time timestamp -- 营业执照有效期开始时间
    ,contacts_idcode varchar2(64) -- 联系人证件号码
    ,manage_type varchar2(32) -- 经营类型
    ,company_prove varchar2(256) -- 单位证明函照片
    ,indoor_photo varchar2(512) -- 内景照
    ,checkstand_photo varchar2(256) -- 收银台照
    ,manager_principal_photo varchar2(256) -- 客户经理与法人合照
    ,register_ip varchar2(64) -- 登记ip
    ,icp_number varchar2(64) -- ICP备案号
    ,merchant_label varchar2(64) -- 商户标签
    ,line_flag number(10,0) -- 条码标识:1公司线，2机构线,3零售线，4数金线
    ,online_verifi_photo varchar2(512) -- 联网核查照
    ,sign_photo varchar2(1024) -- 签名照
    ,protocol_pdf varchar2(1024) -- 影像平台协议PDF地址
    ,customer_no varchar2(128) -- Ecif客户编号
    ,handling_customer_manager_name varchar2(64) -- 经办客户经理
    ,handling_customer_manager_id varchar2(64) -- 经办客户经理工号
    ,handling_bank_branch varchar2(64) -- 经办支行
    ,customer_id varchar2(20) -- 客户号
    ,trade_able_hours_begin varchar2(100) -- 可交易开始时间
    ,trade_able_hours_end varchar2(100) -- 可交易结束时间
    ,points_offer varchar2(10) -- 是否积分优惠
    ,support_farmer_station varchar2(200) -- 
    ,support_farmer number(1,0) -- 
    ,thi_mch_id varchar2(30) -- 第三方商户号
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
grant select on ${iol_schema}.amss_cms_merchant_detail to ${iml_schema};
grant select on ${iol_schema}.amss_cms_merchant_detail to ${icl_schema};
grant select on ${iol_schema}.amss_cms_merchant_detail to ${idl_schema};
grant select on ${iol_schema}.amss_cms_merchant_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_merchant_detail is '商户详细信息表';
comment on column ${iol_schema}.amss_cms_merchant_detail.merchant_detail_id is '商户详细信息ID.使用 商户编号 做商户详细信息的ID';
comment on column ${iol_schema}.amss_cms_merchant_detail.merchant_short_name is '商户简称.';
comment on column ${iol_schema}.amss_cms_merchant_detail.industr_id is '行业类别.关联行业类别表';
comment on column ${iol_schema}.amss_cms_merchant_detail.province is '省份.';
comment on column ${iol_schema}.amss_cms_merchant_detail.city is '城市.';
comment on column ${iol_schema}.amss_cms_merchant_detail.county is '区/县.';
comment on column ${iol_schema}.amss_cms_merchant_detail.address is '地址.';
comment on column ${iol_schema}.amss_cms_merchant_detail.tel is '电话.';
comment on column ${iol_schema}.amss_cms_merchant_detail.email is '邮箱.';
comment on column ${iol_schema}.amss_cms_merchant_detail.web_site is '网址.';
comment on column ${iol_schema}.amss_cms_merchant_detail.principal is '负责人.';
comment on column ${iol_schema}.amss_cms_merchant_detail.id_code is '负责人身份证.';
comment on column ${iol_schema}.amss_cms_merchant_detail.principal_mobile is '负责人手机.';
comment on column ${iol_schema}.amss_cms_merchant_detail.customer_phone is '客服电话.';
comment on column ${iol_schema}.amss_cms_merchant_detail.fax is '传真.';
comment on column ${iol_schema}.amss_cms_merchant_detail.license_photo is '营业执照.';
comment on column ${iol_schema}.amss_cms_merchant_detail.indentity_photo is '身份证照片.';
comment on column ${iol_schema}.amss_cms_merchant_detail.protocol_photo is '商户协议照片.';
comment on column ${iol_schema}.amss_cms_merchant_detail.org_photo is '组织机构代码证照片.';
comment on column ${iol_schema}.amss_cms_merchant_detail.other_doc is '其他资料.资料包，以zip和rar格式上传和下载';
comment on column ${iol_schema}.amss_cms_merchant_detail.physics_flag is '物理标识.1:正常;2:删除';
comment on column ${iol_schema}.amss_cms_merchant_detail.data_source is '数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移';
comment on column ${iol_schema}.amss_cms_merchant_detail.remark is '备注.';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s1 is '门头照路径';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s2 is '营业执照注册号/统一社会信用代码图片路径';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s3 is '营业场所照片路径';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n1 is '性别';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n2 is '(subjectType)商户主体类型';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n3 is '数值型保留字段3.';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_d1 is '日期型保留字段1.';
comment on column ${iol_schema}.amss_cms_merchant_detail.create_user is '创建用户.';
comment on column ${iol_schema}.amss_cms_merchant_detail.create_emp is '创建人.';
comment on column ${iol_schema}.amss_cms_merchant_detail.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_merchant_detail.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_merchant_detail.interface_refund_audit is '接口退款审核';
comment on column ${iol_schema}.amss_cms_merchant_detail.id_code_type is '证件类型';
comment on column ${iol_schema}.amss_cms_merchant_detail.business_license_name is '营业执照名称';
comment on column ${iol_schema}.amss_cms_merchant_detail.account_code_photo is '银行卡/开户许可证图片路径';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n4 is '(fixedPlace)小微商户是否有固定经营场所';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n5 is '注册资本金';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n6 is '';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n7 is '';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_n8 is '';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s4 is '(alipayAccount)保存支付宝账号';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s5 is '(contacts)保存联系人';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s6 is '(businessScope)经营范围';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s7 is '(actualBusinessAddress)实际经营地址';
comment on column ${iol_schema}.amss_cms_merchant_detail.fld_s8 is '(registeredAddress)注册地址';
comment on column ${iol_schema}.amss_cms_merchant_detail.id_code_expire is '身份证到期日.';
comment on column ${iol_schema}.amss_cms_merchant_detail.business_license_expire is '营业执照到期日.';
comment on column ${iol_schema}.amss_cms_merchant_detail.lcaddress is '商户定位地址';
comment on column ${iol_schema}.amss_cms_merchant_detail.questionnaire is '调查表';
comment on column ${iol_schema}.amss_cms_merchant_detail.approval_form is '审批表';
comment on column ${iol_schema}.amss_cms_merchant_detail.thi_doc_id is '第三方文档ID';
comment on column ${iol_schema}.amss_cms_merchant_detail.nationality_num is '国籍编号';
comment on column ${iol_schema}.amss_cms_merchant_detail.principal_profession is '负责人职业';
comment on column ${iol_schema}.amss_cms_merchant_detail.id_code_begin_time is '证件有效期开始时间';
comment on column ${iol_schema}.amss_cms_merchant_detail.business_license_begin_time is '营业执照有效期开始时间';
comment on column ${iol_schema}.amss_cms_merchant_detail.contacts_idcode is '联系人证件号码';
comment on column ${iol_schema}.amss_cms_merchant_detail.manage_type is '经营类型';
comment on column ${iol_schema}.amss_cms_merchant_detail.company_prove is '单位证明函照片';
comment on column ${iol_schema}.amss_cms_merchant_detail.indoor_photo is '内景照';
comment on column ${iol_schema}.amss_cms_merchant_detail.checkstand_photo is '收银台照';
comment on column ${iol_schema}.amss_cms_merchant_detail.manager_principal_photo is '客户经理与法人合照';
comment on column ${iol_schema}.amss_cms_merchant_detail.register_ip is '登记ip';
comment on column ${iol_schema}.amss_cms_merchant_detail.icp_number is 'ICP备案号';
comment on column ${iol_schema}.amss_cms_merchant_detail.merchant_label is '商户标签';
comment on column ${iol_schema}.amss_cms_merchant_detail.line_flag is '条码标识:1公司线，2机构线,3零售线，4数金线';
comment on column ${iol_schema}.amss_cms_merchant_detail.online_verifi_photo is '联网核查照';
comment on column ${iol_schema}.amss_cms_merchant_detail.sign_photo is '签名照';
comment on column ${iol_schema}.amss_cms_merchant_detail.protocol_pdf is '影像平台协议PDF地址';
comment on column ${iol_schema}.amss_cms_merchant_detail.customer_no is 'Ecif客户编号';
comment on column ${iol_schema}.amss_cms_merchant_detail.handling_customer_manager_name is '经办客户经理';
comment on column ${iol_schema}.amss_cms_merchant_detail.handling_customer_manager_id is '经办客户经理工号';
comment on column ${iol_schema}.amss_cms_merchant_detail.handling_bank_branch is '经办支行';
comment on column ${iol_schema}.amss_cms_merchant_detail.customer_id is '客户号';
comment on column ${iol_schema}.amss_cms_merchant_detail.trade_able_hours_begin is '可交易开始时间';
comment on column ${iol_schema}.amss_cms_merchant_detail.trade_able_hours_end is '可交易结束时间';
comment on column ${iol_schema}.amss_cms_merchant_detail.points_offer is '是否积分优惠';
comment on column ${iol_schema}.amss_cms_merchant_detail.support_farmer_station is '';
comment on column ${iol_schema}.amss_cms_merchant_detail.support_farmer is '';
comment on column ${iol_schema}.amss_cms_merchant_detail.thi_mch_id is '第三方商户号';
comment on column ${iol_schema}.amss_cms_merchant_detail.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_merchant_detail.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_merchant_detail.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_merchant_detail.etl_timestamp is 'ETL处理时间戳';
