/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl scps_bp_rpa_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.scps_bp_rpa_tb
whenever sqlerror continue none;
drop table ${idl_schema}.scps_bp_rpa_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.scps_bp_rpa_tb(
    etl_dt date -- ETL处理日期
    ,id varchar2(36) -- 主键
    ,task_id varchar2(33) -- 流水号
    ,create_time date -- 创建时间
    ,start_time date -- 人行备案开始时间
    ,end_time date -- 人行备案结束时间
    ,people_fail_reason varchar2(1000) -- 人行备案失败原因
    ,query_type varchar2(2) -- 查询登记类型:1登记2变更
    ,ilegal_relat_company varchar2(50) -- 法人关联企业
    ,ilegal_relat_acctno varchar2(50) -- 法人关联账户
    ,ilegal_phone_relat_acctno varchar2(50) -- 法人同一手机号码关联账户
    ,oprerator_relat_acctno varchar2(50) -- 经办人关联账户
    ,oprerator_phone_relat_acctno varchar2(50) -- 经办人同一手机号码关联账户
    ,similar_relat_acctno varchar2(50) -- 相似关联账户
    ,similar_addr_relat_company varchar2(50) -- 相似住所关联企业
    ,is_hanging_acctno varchar2(50) -- 是否久悬账户
    ,rec_type varchar2(4) -- 备案类型：0本地备案1异地备案
    ,people_bank_rpa_result varchar2(2) -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,guangdong_company_rpa_result varchar2(2) -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,guangdong_company_fail_reason varchar2(1000) -- 广东省企业备案失败原因
    ,des_file_name varchar2(200) -- 本地文件路径名
    ,sdi_file_path varchar2(50) -- 远程凭证路径
    ,gd_start_time date -- 广东备案开始时间
    ,gd_end_time date -- 广东备案结束时间
    ,people_bank_query_rpa_result varchar2(2) -- 人行信息查询结果-0未返回、-1正常、-2异常
    ,people_bank_query_rpa_fr varchar2(1000) -- 人行信息查询失败原因
    ,guangdong_record_rpa_result varchar2(2) -- 广东省信息查询结果-0未返回、-1正常、-2异常
    ,guangdong_record_rpa_fr varchar2(1000) -- 广东省信息查询失败原因
    ,sz_image_result varchar2(2) -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,sz_image_fail_reason varchar2(1000) -- 深圳影像备案失败原因
    ,sz_start_time date -- 深圳影像备案开始时间
    ,sz_end_time date -- 深圳影像备案结束时间
    ,is_flag varchar2(1) -- 标记是否记录过备案信息1为是0为否
    ,pw_file_name varchar2(200) -- 存款人查询密码影像名称
    ,pw_file_path varchar2(50) -- 存款人查询密码影像路径
    ,op_account_num varchar2(50) -- 开户许可证编号
    ,gd_notsz_flag varchar2(1) -- 深圳开户企业标记-1是2否
    ,old_open_licen varchar2(50) -- 原开户许可证号
    ,sz_is_have_id varchar2(2) -- 是否有证1有2没有
    ,arcid varchar2(32) -- 案卷表ID
    ,pboc varchar2(2) -- 人行查询（0为不查询，1为查询）
    ,ebank varchar2(2) -- E路通查询(0为不查询,1为查询)
    ,iselsewhere varchar2(2) -- 是否异地(人行；0否，1是)
    ,cust_name varchar2(200) -- 存款人名称
    ,deposit_type varchar2(3) -- 存款人类别
    ,telephone varchar2(30) -- 电话
    ,compay_fin_type varchar2(20) -- 法人种类
    ,principal_name varchar2(200) -- 法人姓名
    ,principal_papers_type varchar2(32) -- 法人证件种类
    ,principal_papers_number varchar2(60) -- 法人证件号码
    ,district_code varchar2(6) -- 行政区划
    ,register_curr_type varchar2(5) -- 注册资金币种
    ,registerfund number(20,2) -- 注册资金
    ,compay_organiz_code varchar2(100) -- 组织机构代码
    ,papers_type varchar2(32) -- 第一证明文件种类
    ,papers_number varchar2(32) -- 第一证明文件编号
    ,papers_type2 varchar2(32) -- 第二证明文件种类
    ,papers_number2 varchar2(32) -- 第二证明文件编号
    ,nat_register_no varchar2(32) -- 国税登记证号
    ,local_register_no varchar2(32) -- 地税税登记证号
    ,contact_address varchar2(400) -- 地址
    ,operate_scope varchar2(4000) -- 经营范围
    ,torpa_compay_oragniz_code varchar2(40) -- RPA备案上级法人组织机构代码
    ,organiz_code varchar2(32) -- RPA备案组织机构代码
    ,papers_kind varchar2(32) -- 第一证明文件种类(预受理)
    ,papers_id varchar2(32) -- 第一证明文件编号（预受理）
    ,approveno varchar2(32) -- 核准号(人行)
    ,distinctcode varchar2(6) -- 行政区划
    ,brcode varchar2(10) -- 网点号(人行)
    ,imagename varchar2(200) -- 图片名
    ,filepath varchar2(200) -- 路径
    ,cust_name_eb varchar2(200) -- 存款人(E路通)
    ,papers_number_eb varchar2(128) -- 营业执照号码(E路通)
    ,principal_name_eb varchar2(200) -- 法人姓名(E路通)
    ,principal_papers_type_eb varchar2(32) -- 法人证件种类(E路通)
    ,principal_papers_number_eb varchar2(60) -- (E路通)法人证件号码
    ,phone_eb varchar2(30) -- (E路通)法人电话号码
    ,contact_address_eb varchar2(200) -- 地址(E路通)
    ,proxy_name_eb varchar2(200) -- 经办人姓名(E路通)
    ,proxy_papers_type_eb varchar2(32) -- 经办人证件种类(E路通)
    ,proxy_papers_number_eb varchar2(60) -- (E路通)经办人证件号码
    ,proxy_phone_eb varchar2(30) -- (E路通)经办人电话号码
    ,uuid varchar2(32) -- 图片ID(E路通)
    ,isorganizpaper varchar2(2) -- 组织机构代码证是否为第一证件（0否，1是）
    ,papers_contact_address varchar2(400) -- （营业执照）注册地址
    ,papers_principal_name varchar2(200) -- 法人姓名（营业执照）
    ,papers_papers_number varchar2(60) -- （营业执照）证件号码
    ,papers_cust_name varchar2(200) -- 存款人（营业执照）
    ,papers_registerfund varchar2(400) -- 注册资金（营业执照）
    ,papers_operate_scope varchar2(4000) -- （营业执照）经营范围
    ,torpa_nat_register_no varchar2(32) -- RPA备案国税登记证号
    ,torpa_local_register_no varchar2(32) -- RPA备案地税登记证号
    ,is_need_eluton_inchange varchar2(40) -- 是否需要改变（E路通）1-需要，2-不需要
    ,torpa_scope varchar2(1000) -- 送RPA备案经营范围
    ,torpa_found_date varchar2(10) -- 送RPA备案成立日
    ,torpa_call_phone varchar2(30) -- 送RPA备案联系电话
    ,papers_type_eb varchar2(4) -- 第一证件类型
    ,registerfund_eb varchar2(50) -- 注册资金（送变更人行）
    ,istoscope_pb varchar2(2) -- 是否变更经营范围（送变更人行）-1是-2否
    ,deposit_type_eb varchar2(3) -- （变更送E路通）存款人类别
    ,acct_opendt_eb date -- 客户开户日期
    ,trade_type_eb varchar2(5) -- 所属行业类型
    ,found_date_eb varchar2(10) -- 成立日期（变更送E路通）
    ,perpers_invaldt_eb varchar2(20) -- 营业期限（变更送E路通）
    ,principal_invaldt_eb date -- 证件生效日期
    ,acct_name_eb varchar2(200) -- 账户名称（送变更E路通）
    ,rpa_people_count varchar2(2) -- 人行备案次数
    ,rpa_manual_record varchar2(2) -- 是否人工备案：1-是其他-否
    ,rpa_max_count varchar2(2) -- 配置循环备案最大数次
    ,ecfi_papers_t varchar2(32) -- 原Ecif第二证件值
    ,biz_code varchar2(6) -- 业务编码
    ,start_dt date -- 开始日期
    ,end_dt date -- 结束日期
    ,id_mark varchar2(10) -- 删除标识
    ,e_docid varchar2(100) -- 人行查备案返回图片批次号
    ,acct_no varchar2(32) -- 账号
    ,old_approve_no varchar2(40) -- 原基本存款账户编号
    ,doc_id varchar2(100) -- 开户/变更时影像批次号
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.scps_bp_rpa_tb to ${iel_schema};

-- comment
comment on table ${idl_schema}.scps_bp_rpa_tb is 'rpa记录表';
comment on column ${idl_schema}.scps_bp_rpa_tb.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.scps_bp_rpa_tb.id is '主键';
comment on column ${idl_schema}.scps_bp_rpa_tb.task_id is '流水号';
comment on column ${idl_schema}.scps_bp_rpa_tb.create_time is '创建时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.start_time is '人行备案开始时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.end_time is '人行备案结束时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.people_fail_reason is '人行备案失败原因';
comment on column ${idl_schema}.scps_bp_rpa_tb.query_type is '查询登记类型:1登记2变更';
comment on column ${idl_schema}.scps_bp_rpa_tb.ilegal_relat_company is '法人关联企业';
comment on column ${idl_schema}.scps_bp_rpa_tb.ilegal_relat_acctno is '法人关联账户';
comment on column ${idl_schema}.scps_bp_rpa_tb.ilegal_phone_relat_acctno is '法人同一手机号码关联账户';
comment on column ${idl_schema}.scps_bp_rpa_tb.oprerator_relat_acctno is '经办人关联账户';
comment on column ${idl_schema}.scps_bp_rpa_tb.oprerator_phone_relat_acctno is '经办人同一手机号码关联账户';
comment on column ${idl_schema}.scps_bp_rpa_tb.similar_relat_acctno is '相似关联账户';
comment on column ${idl_schema}.scps_bp_rpa_tb.similar_addr_relat_company is '相似住所关联企业';
comment on column ${idl_schema}.scps_bp_rpa_tb.is_hanging_acctno is '是否久悬账户';
comment on column ${idl_schema}.scps_bp_rpa_tb.rec_type is '备案类型：0本地备案1异地备案';
comment on column ${idl_schema}.scps_bp_rpa_tb.people_bank_rpa_result is '人行备案结果：0未备案1备案失败2备案成功3备案中';
comment on column ${idl_schema}.scps_bp_rpa_tb.guangdong_company_rpa_result is '广东省企业备案结果：0未备案1备案失败2备案成功3备案中';
comment on column ${idl_schema}.scps_bp_rpa_tb.guangdong_company_fail_reason is '广东省企业备案失败原因';
comment on column ${idl_schema}.scps_bp_rpa_tb.des_file_name is '本地文件路径名';
comment on column ${idl_schema}.scps_bp_rpa_tb.sdi_file_path is '远程凭证路径';
comment on column ${idl_schema}.scps_bp_rpa_tb.gd_start_time is '广东备案开始时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.gd_end_time is '广东备案结束时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.people_bank_query_rpa_result is '人行信息查询结果-0未返回、-1正常、-2异常';
comment on column ${idl_schema}.scps_bp_rpa_tb.people_bank_query_rpa_fr is '人行信息查询失败原因';
comment on column ${idl_schema}.scps_bp_rpa_tb.guangdong_record_rpa_result is '广东省信息查询结果-0未返回、-1正常、-2异常';
comment on column ${idl_schema}.scps_bp_rpa_tb.guangdong_record_rpa_fr is '广东省信息查询失败原因';
comment on column ${idl_schema}.scps_bp_rpa_tb.sz_image_result is '深圳影像备案结果：0未备案1备案失败2备案成功3备案中';
comment on column ${idl_schema}.scps_bp_rpa_tb.sz_image_fail_reason is '深圳影像备案失败原因';
comment on column ${idl_schema}.scps_bp_rpa_tb.sz_start_time is '深圳影像备案开始时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.sz_end_time is '深圳影像备案结束时间';
comment on column ${idl_schema}.scps_bp_rpa_tb.is_flag is '标记是否记录过备案信息1为是0为否';
comment on column ${idl_schema}.scps_bp_rpa_tb.pw_file_name is '存款人查询密码影像名称';
comment on column ${idl_schema}.scps_bp_rpa_tb.pw_file_path is '存款人查询密码影像路径';
comment on column ${idl_schema}.scps_bp_rpa_tb.op_account_num is '开户许可证编号';
comment on column ${idl_schema}.scps_bp_rpa_tb.gd_notsz_flag is '深圳开户企业标记-1是2否';
comment on column ${idl_schema}.scps_bp_rpa_tb.old_open_licen is '原开户许可证号';
comment on column ${idl_schema}.scps_bp_rpa_tb.sz_is_have_id is '是否有证1有2没有';
comment on column ${idl_schema}.scps_bp_rpa_tb.arcid is '案卷表ID';
comment on column ${idl_schema}.scps_bp_rpa_tb.pboc is '人行查询（0为不查询，1为查询）';
comment on column ${idl_schema}.scps_bp_rpa_tb.ebank is 'E路通查询(0为不查询,1为查询)';
comment on column ${idl_schema}.scps_bp_rpa_tb.iselsewhere is '是否异地(人行；0否，1是)';
comment on column ${idl_schema}.scps_bp_rpa_tb.cust_name is '存款人名称';
comment on column ${idl_schema}.scps_bp_rpa_tb.deposit_type is '存款人类别';
comment on column ${idl_schema}.scps_bp_rpa_tb.telephone is '电话';
comment on column ${idl_schema}.scps_bp_rpa_tb.compay_fin_type is '法人种类';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_name is '法人姓名';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_papers_type is '法人证件种类';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_papers_number is '法人证件号码';
comment on column ${idl_schema}.scps_bp_rpa_tb.district_code is '行政区划';
comment on column ${idl_schema}.scps_bp_rpa_tb.register_curr_type is '注册资金币种';
comment on column ${idl_schema}.scps_bp_rpa_tb.registerfund is '注册资金';
comment on column ${idl_schema}.scps_bp_rpa_tb.compay_organiz_code is '组织机构代码';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_type is '第一证明文件种类';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_number is '第一证明文件编号';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_type2 is '第二证明文件种类';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_number2 is '第二证明文件编号';
comment on column ${idl_schema}.scps_bp_rpa_tb.nat_register_no is '国税登记证号';
comment on column ${idl_schema}.scps_bp_rpa_tb.local_register_no is '地税税登记证号';
comment on column ${idl_schema}.scps_bp_rpa_tb.contact_address is '地址';
comment on column ${idl_schema}.scps_bp_rpa_tb.operate_scope is '经营范围';
comment on column ${idl_schema}.scps_bp_rpa_tb.torpa_compay_oragniz_code is 'RPA备案上级法人组织机构代码';
comment on column ${idl_schema}.scps_bp_rpa_tb.organiz_code is 'RPA备案组织机构代码';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_kind is '第一证明文件种类(预受理)';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_id is '第一证明文件编号（预受理）';
comment on column ${idl_schema}.scps_bp_rpa_tb.approveno is '核准号(人行)';
comment on column ${idl_schema}.scps_bp_rpa_tb.distinctcode is '行政区划';
comment on column ${idl_schema}.scps_bp_rpa_tb.brcode is '网点号(人行)';
comment on column ${idl_schema}.scps_bp_rpa_tb.imagename is '图片名';
comment on column ${idl_schema}.scps_bp_rpa_tb.filepath is '路径';
comment on column ${idl_schema}.scps_bp_rpa_tb.cust_name_eb is '存款人(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_number_eb is '营业执照号码(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_name_eb is '法人姓名(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_papers_type_eb is '法人证件种类(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_papers_number_eb is '(E路通)法人证件号码';
comment on column ${idl_schema}.scps_bp_rpa_tb.phone_eb is '(E路通)法人电话号码';
comment on column ${idl_schema}.scps_bp_rpa_tb.contact_address_eb is '地址(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.proxy_name_eb is '经办人姓名(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.proxy_papers_type_eb is '经办人证件种类(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.proxy_papers_number_eb is '(E路通)经办人证件号码';
comment on column ${idl_schema}.scps_bp_rpa_tb.proxy_phone_eb is '(E路通)经办人电话号码';
comment on column ${idl_schema}.scps_bp_rpa_tb.uuid is '图片ID(E路通)';
comment on column ${idl_schema}.scps_bp_rpa_tb.isorganizpaper is '组织机构代码证是否为第一证件（0否，1是）';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_contact_address is '（营业执照）注册地址';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_principal_name is '法人姓名（营业执照）';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_papers_number is '（营业执照）证件号码';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_cust_name is '存款人（营业执照）';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_registerfund is '注册资金（营业执照）';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_operate_scope is '（营业执照）经营范围';
comment on column ${idl_schema}.scps_bp_rpa_tb.torpa_nat_register_no is 'RPA备案国税登记证号';
comment on column ${idl_schema}.scps_bp_rpa_tb.torpa_local_register_no is 'RPA备案地税登记证号';
comment on column ${idl_schema}.scps_bp_rpa_tb.is_need_eluton_inchange is '是否需要改变（E路通）1-需要，2-不需要';
comment on column ${idl_schema}.scps_bp_rpa_tb.torpa_scope is '送RPA备案经营范围';
comment on column ${idl_schema}.scps_bp_rpa_tb.torpa_found_date is '送RPA备案成立日';
comment on column ${idl_schema}.scps_bp_rpa_tb.torpa_call_phone is '送RPA备案联系电话';
comment on column ${idl_schema}.scps_bp_rpa_tb.papers_type_eb is '第一证件类型';
comment on column ${idl_schema}.scps_bp_rpa_tb.registerfund_eb is '注册资金（送变更人行）';
comment on column ${idl_schema}.scps_bp_rpa_tb.istoscope_pb is '是否变更经营范围（送变更人行）-1是-2否';
comment on column ${idl_schema}.scps_bp_rpa_tb.deposit_type_eb is '（变更送E路通）存款人类别';
comment on column ${idl_schema}.scps_bp_rpa_tb.acct_opendt_eb is '客户开户日期';
comment on column ${idl_schema}.scps_bp_rpa_tb.trade_type_eb is '所属行业类型';
comment on column ${idl_schema}.scps_bp_rpa_tb.found_date_eb is '成立日期（变更送E路通）';
comment on column ${idl_schema}.scps_bp_rpa_tb.perpers_invaldt_eb is '营业期限（变更送E路通）';
comment on column ${idl_schema}.scps_bp_rpa_tb.principal_invaldt_eb is '证件生效日期';
comment on column ${idl_schema}.scps_bp_rpa_tb.acct_name_eb is '账户名称（送变更E路通）';
comment on column ${idl_schema}.scps_bp_rpa_tb.rpa_people_count is '人行备案次数';
comment on column ${idl_schema}.scps_bp_rpa_tb.rpa_manual_record is '是否人工备案：1-是其他-否';
comment on column ${idl_schema}.scps_bp_rpa_tb.rpa_max_count is '配置循环备案最大数次';
comment on column ${idl_schema}.scps_bp_rpa_tb.ecfi_papers_t is '原Ecif第二证件值';
comment on column ${idl_schema}.scps_bp_rpa_tb.biz_code is '业务编码';
comment on column ${idl_schema}.scps_bp_rpa_tb.start_dt is '开始日期';
comment on column ${idl_schema}.scps_bp_rpa_tb.end_dt is '结束日期';
comment on column ${idl_schema}.scps_bp_rpa_tb.id_mark is '删除标识';
comment on column ${idl_schema}.scps_bp_rpa_tb.e_docid is '人行查备案返回图片批次号';
comment on column ${idl_schema}.scps_bp_rpa_tb.acct_no is '账号';
comment on column ${idl_schema}.scps_bp_rpa_tb.old_approve_no is '原基本存款账户编号';
comment on column ${idl_schema}.scps_bp_rpa_tb.doc_id is '开户/变更时影像批次号';
comment on column ${idl_schema}.scps_bp_rpa_tb.job_cd is '任务代码';
comment on column ${idl_schema}.scps_bp_rpa_tb.etl_timestamp is 'ETL处理时间戳';