/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl scps_bp_rpa_tb
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.scps_bp_rpa_tb drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.scps_bp_rpa_tb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.scps_bp_rpa_tb partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,id  -- 主键
    ,task_id  -- 流水号
    ,create_time  -- 创建时间
    ,start_time  -- 人行备案开始时间
    ,end_time  -- 人行备案结束时间
    ,people_fail_reason  -- 人行备案失败原因
    ,query_type  -- 查询登记类型:1登记2变更
    ,ilegal_relat_company  -- 法人关联企业
    ,ilegal_relat_acctno  -- 法人关联账户
    ,ilegal_phone_relat_acctno  -- 法人同一手机号码关联账户
    ,oprerator_relat_acctno  -- 经办人关联账户
    ,oprerator_phone_relat_acctno  -- 经办人同一手机号码关联账户
    ,similar_relat_acctno  -- 相似关联账户
    ,similar_addr_relat_company  -- 相似住所关联企业
    ,is_hanging_acctno  -- 是否久悬账户
    ,rec_type  -- 备案类型：0本地备案1异地备案
    ,people_bank_rpa_result  -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,guangdong_company_rpa_result  -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,guangdong_company_fail_reason  -- 广东省企业备案失败原因
    ,des_file_name  -- 本地文件路径名
    ,sdi_file_path  -- 远程凭证路径
    ,gd_start_time  -- 广东备案开始时间
    ,gd_end_time  -- 广东备案结束时间
    ,people_bank_query_rpa_result  -- 人行信息查询结果-0未返回、-1正常、-2异常
    ,people_bank_query_rpa_fr  -- 人行信息查询失败原因
    ,guangdong_record_rpa_result  -- 广东省信息查询结果-0未返回、-1正常、-2异常
    ,guangdong_record_rpa_fr  -- 广东省信息查询失败原因
    ,sz_image_result  -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,sz_image_fail_reason  -- 深圳影像备案失败原因
    ,sz_start_time  -- 深圳影像备案开始时间
    ,sz_end_time  -- 深圳影像备案结束时间
    ,is_flag  -- 标记是否记录过备案信息1为是0为否
    ,pw_file_name  -- 存款人查询密码影像名称
    ,pw_file_path  -- 存款人查询密码影像路径
    ,op_account_num  -- 开户许可证编号
    ,gd_notsz_flag  -- 深圳开户企业标记-1是2否
    ,old_open_licen  -- 原开户许可证号
    ,sz_is_have_id  -- 是否有证1有2没有
    ,arcid  -- 案卷表ID
    ,pboc  -- 人行查询（0为不查询，1为查询）
    ,ebank  -- E路通查询(0为不查询,1为查询)
    ,iselsewhere  -- 是否异地(人行；0否，1是)
    ,cust_name  -- 存款人名称
    ,deposit_type  -- 存款人类别
    ,telephone  -- 电话
    ,compay_fin_type  -- 法人种类
    ,principal_name  -- 法人姓名
    ,principal_papers_type  -- 法人证件种类
    ,principal_papers_number  -- 法人证件号码
    ,district_code  -- 行政区划
    ,register_curr_type  -- 注册资金币种
    ,registerfund  -- 注册资金
    ,compay_organiz_code  -- 组织机构代码
    ,papers_type  -- 第一证明文件种类
    ,papers_number  -- 第一证明文件编号
    ,papers_type2  -- 第二证明文件种类
    ,papers_number2  -- 第二证明文件编号
    ,nat_register_no  -- 国税登记证号
    ,local_register_no  -- 地税税登记证号
    ,contact_address  -- 地址
    ,operate_scope  -- 经营范围
    ,torpa_compay_oragniz_code  -- RPA备案上级法人组织机构代码
    ,organiz_code  -- RPA备案组织机构代码
    ,papers_kind  -- 第一证明文件种类(预受理)
    ,papers_id  -- 第一证明文件编号（预受理）
    ,approveno  -- 核准号(人行)
    ,distinctcode  -- 行政区划
    ,brcode  -- 网点号(人行)
    ,imagename  -- 图片名
    ,filepath  -- 路径
    ,cust_name_eb  -- 存款人(E路通)
    ,papers_number_eb  -- 营业执照号码(E路通)
    ,principal_name_eb  -- 法人姓名(E路通)
    ,principal_papers_type_eb  -- 法人证件种类(E路通)
    ,principal_papers_number_eb  -- (E路通)法人证件号码
    ,phone_eb  -- (E路通)法人电话号码
    ,contact_address_eb  -- 地址(E路通)
    ,proxy_name_eb  -- 经办人姓名(E路通)
    ,proxy_papers_type_eb  -- 经办人证件种类(E路通)
    ,proxy_papers_number_eb  -- (E路通)经办人证件号码
    ,proxy_phone_eb  -- (E路通)经办人电话号码
    ,uuid  -- 图片ID(E路通)
    ,isorganizpaper  -- 组织机构代码证是否为第一证件（0否，1是）
    ,papers_contact_address  -- （营业执照）注册地址
    ,papers_principal_name  -- 法人姓名（营业执照）
    ,papers_papers_number  -- （营业执照）证件号码
    ,papers_cust_name  -- 存款人（营业执照）
    ,papers_registerfund  -- 注册资金（营业执照）
    ,papers_operate_scope  -- （营业执照）经营范围
    ,torpa_nat_register_no  -- RPA备案国税登记证号
    ,torpa_local_register_no  -- RPA备案地税登记证号
    ,is_need_eluton_inchange  -- 是否需要改变（E路通）1-需要，2-不需要
    ,torpa_scope  -- 送RPA备案经营范围
    ,torpa_found_date  -- 送RPA备案成立日
    ,torpa_call_phone  -- 送RPA备案联系电话
    ,papers_type_eb  -- 第一证件类型
    ,registerfund_eb  -- 注册资金（送变更人行）
    ,istoscope_pb  -- 是否变更经营范围（送变更人行）-1是-2否
    ,deposit_type_eb  -- （变更送E路通）存款人类别
    ,acct_opendt_eb  -- 客户开户日期
    ,trade_type_eb  -- 所属行业类型
    ,found_date_eb  -- 成立日期（变更送E路通）
    ,perpers_invaldt_eb  -- 营业期限（变更送E路通）
    ,principal_invaldt_eb  -- 证件生效日期
    ,acct_name_eb  -- 账户名称（送变更E路通）
    ,rpa_people_count  -- 人行备案次数
    ,rpa_manual_record  -- 是否人工备案：1-是其他-否
    ,rpa_max_count  -- 配置循环备案最大数次
    ,ecfi_papers_t  -- 原Ecif第二证件值
    ,biz_code  -- 业务编码
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,e_docid  -- 人行查备案返回图片批次号
    ,acct_no  -- 账号
    ,old_approve_no  -- 原基本存款账户编号
    ,doc_id  -- 开户/变更时影像批次号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id  -- 主键
    ,replace(replace(t.task_id,chr(13),''),chr(10),'') as task_id  -- 流水号
    ,t.create_time as create_time  -- 创建时间
    ,t.start_time as start_time  -- 人行备案开始时间
    ,t.end_time as end_time  -- 人行备案结束时间
    ,replace(replace(t.people_fail_reason,chr(13),''),chr(10),'') as people_fail_reason  -- 人行备案失败原因
    ,replace(replace(t.query_type,chr(13),''),chr(10),'') as query_type  -- 查询登记类型:1登记2变更
    ,replace(replace(t.ilegal_relat_company,chr(13),''),chr(10),'') as ilegal_relat_company  -- 法人关联企业
    ,replace(replace(t.ilegal_relat_acctno,chr(13),''),chr(10),'') as ilegal_relat_acctno  -- 法人关联账户
    ,replace(replace(t.ilegal_phone_relat_acctno,chr(13),''),chr(10),'') as ilegal_phone_relat_acctno  -- 法人同一手机号码关联账户
    ,replace(replace(t.oprerator_relat_acctno,chr(13),''),chr(10),'') as oprerator_relat_acctno  -- 经办人关联账户
    ,replace(replace(t.oprerator_phone_relat_acctno,chr(13),''),chr(10),'') as oprerator_phone_relat_acctno  -- 经办人同一手机号码关联账户
    ,replace(replace(t.similar_relat_acctno,chr(13),''),chr(10),'') as similar_relat_acctno  -- 相似关联账户
    ,replace(replace(t.similar_addr_relat_company,chr(13),''),chr(10),'') as similar_addr_relat_company  -- 相似住所关联企业
    ,replace(replace(t.is_hanging_acctno,chr(13),''),chr(10),'') as is_hanging_acctno  -- 是否久悬账户
    ,replace(replace(t.rec_type,chr(13),''),chr(10),'') as rec_type  -- 备案类型：0本地备案1异地备案
    ,replace(replace(t.people_bank_rpa_result,chr(13),''),chr(10),'') as people_bank_rpa_result  -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,replace(replace(t.guangdong_company_rpa_result,chr(13),''),chr(10),'') as guangdong_company_rpa_result  -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,replace(replace(t.guangdong_company_fail_reason,chr(13),''),chr(10),'') as guangdong_company_fail_reason  -- 广东省企业备案失败原因
    ,replace(replace(t.des_file_name,chr(13),''),chr(10),'') as des_file_name  -- 本地文件路径名
    ,replace(replace(t.sdi_file_path,chr(13),''),chr(10),'') as sdi_file_path  -- 远程凭证路径
    ,t.gd_start_time as gd_start_time  -- 广东备案开始时间
    ,t.gd_end_time as gd_end_time  -- 广东备案结束时间
    ,replace(replace(t.people_bank_query_rpa_result,chr(13),''),chr(10),'') as people_bank_query_rpa_result  -- 人行信息查询结果-0未返回、-1正常、-2异常
    ,replace(replace(t.people_bank_query_rpa_fr,chr(13),''),chr(10),'') as people_bank_query_rpa_fr  -- 人行信息查询失败原因
    ,replace(replace(t.guangdong_record_rpa_result,chr(13),''),chr(10),'') as guangdong_record_rpa_result  -- 广东省信息查询结果-0未返回、-1正常、-2异常
    ,replace(replace(t.guangdong_record_rpa_fr,chr(13),''),chr(10),'') as guangdong_record_rpa_fr  -- 广东省信息查询失败原因
    ,replace(replace(t.sz_image_result,chr(13),''),chr(10),'') as sz_image_result  -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,replace(replace(t.sz_image_fail_reason,chr(13),''),chr(10),'') as sz_image_fail_reason  -- 深圳影像备案失败原因
    ,t.sz_start_time as sz_start_time  -- 深圳影像备案开始时间
    ,t.sz_end_time as sz_end_time  -- 深圳影像备案结束时间
    ,replace(replace(t.is_flag,chr(13),''),chr(10),'') as is_flag  -- 标记是否记录过备案信息1为是0为否
    ,replace(replace(t.pw_file_name,chr(13),''),chr(10),'') as pw_file_name  -- 存款人查询密码影像名称
    ,replace(replace(t.pw_file_path,chr(13),''),chr(10),'') as pw_file_path  -- 存款人查询密码影像路径
    ,replace(replace(t.op_account_num,chr(13),''),chr(10),'') as op_account_num  -- 开户许可证编号
    ,replace(replace(t.gd_notsz_flag,chr(13),''),chr(10),'') as gd_notsz_flag  -- 深圳开户企业标记-1是2否
    ,replace(replace(t.old_open_licen,chr(13),''),chr(10),'') as old_open_licen  -- 原开户许可证号
    ,replace(replace(t.sz_is_have_id,chr(13),''),chr(10),'') as sz_is_have_id  -- 是否有证1有2没有
    ,replace(replace(t.arcid,chr(13),''),chr(10),'') as arcid  -- 案卷表ID
    ,replace(replace(t.pboc,chr(13),''),chr(10),'') as pboc  -- 人行查询（0为不查询，1为查询）
    ,replace(replace(t.ebank,chr(13),''),chr(10),'') as ebank  -- E路通查询(0为不查询,1为查询)
    ,replace(replace(t.iselsewhere,chr(13),''),chr(10),'') as iselsewhere  -- 是否异地(人行；0否，1是)
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name  -- 存款人名称
    ,replace(replace(t.deposit_type,chr(13),''),chr(10),'') as deposit_type  -- 存款人类别
    ,replace(replace(t.telephone,chr(13),''),chr(10),'') as telephone  -- 电话
    ,replace(replace(t.compay_fin_type,chr(13),''),chr(10),'') as compay_fin_type  -- 法人种类
    ,replace(replace(t.principal_name,chr(13),''),chr(10),'') as principal_name  -- 法人姓名
    ,replace(replace(t.principal_papers_type,chr(13),''),chr(10),'') as principal_papers_type  -- 法人证件种类
    ,replace(replace(t.principal_papers_number,chr(13),''),chr(10),'') as principal_papers_number  -- 法人证件号码
    ,replace(replace(t.district_code,chr(13),''),chr(10),'') as district_code  -- 行政区划
    ,replace(replace(t.register_curr_type,chr(13),''),chr(10),'') as register_curr_type  -- 注册资金币种
    ,t.registerfund as registerfund  -- 注册资金
    ,replace(replace(t.compay_organiz_code,chr(13),''),chr(10),'') as compay_organiz_code  -- 组织机构代码
    ,replace(replace(t.papers_type,chr(13),''),chr(10),'') as papers_type  -- 第一证明文件种类
    ,replace(replace(t.papers_number,chr(13),''),chr(10),'') as papers_number  -- 第一证明文件编号
    ,replace(replace(t.papers_type2,chr(13),''),chr(10),'') as papers_type2  -- 第二证明文件种类
    ,replace(replace(t.papers_number2,chr(13),''),chr(10),'') as papers_number2  -- 第二证明文件编号
    ,replace(replace(t.nat_register_no,chr(13),''),chr(10),'') as nat_register_no  -- 国税登记证号
    ,replace(replace(t.local_register_no,chr(13),''),chr(10),'') as local_register_no  -- 地税税登记证号
    ,replace(replace(t.contact_address,chr(13),''),chr(10),'') as contact_address  -- 地址
    ,replace(replace(t.operate_scope,chr(13),''),chr(10),'') as operate_scope  -- 经营范围
    ,replace(replace(t.torpa_compay_oragniz_code,chr(13),''),chr(10),'') as torpa_compay_oragniz_code  -- RPA备案上级法人组织机构代码
    ,replace(replace(t.organiz_code,chr(13),''),chr(10),'') as organiz_code  -- RPA备案组织机构代码
    ,replace(replace(t.papers_kind,chr(13),''),chr(10),'') as papers_kind  -- 第一证明文件种类(预受理)
    ,replace(replace(t.papers_id,chr(13),''),chr(10),'') as papers_id  -- 第一证明文件编号（预受理）
    ,replace(replace(t.approveno,chr(13),''),chr(10),'') as approveno  -- 核准号(人行)
    ,replace(replace(t.distinctcode,chr(13),''),chr(10),'') as distinctcode  -- 行政区划
    ,replace(replace(t.brcode,chr(13),''),chr(10),'') as brcode  -- 网点号(人行)
    ,replace(replace(t.imagename,chr(13),''),chr(10),'') as imagename  -- 图片名
    ,replace(replace(t.filepath,chr(13),''),chr(10),'') as filepath  -- 路径
    ,replace(replace(t.cust_name_eb,chr(13),''),chr(10),'') as cust_name_eb  -- 存款人(E路通)
    ,replace(replace(t.papers_number_eb,chr(13),''),chr(10),'') as papers_number_eb  -- 营业执照号码(E路通)
    ,replace(replace(t.principal_name_eb,chr(13),''),chr(10),'') as principal_name_eb  -- 法人姓名(E路通)
    ,replace(replace(t.principal_papers_type_eb,chr(13),''),chr(10),'') as principal_papers_type_eb  -- 法人证件种类(E路通)
    ,replace(replace(t.principal_papers_number_eb,chr(13),''),chr(10),'') as principal_papers_number_eb  -- (E路通)法人证件号码
    ,replace(replace(t.phone_eb,chr(13),''),chr(10),'') as phone_eb  -- (E路通)法人电话号码
    ,replace(replace(t.contact_address_eb,chr(13),''),chr(10),'') as contact_address_eb  -- 地址(E路通)
    ,replace(replace(t.proxy_name_eb,chr(13),''),chr(10),'') as proxy_name_eb  -- 经办人姓名(E路通)
    ,replace(replace(t.proxy_papers_type_eb,chr(13),''),chr(10),'') as proxy_papers_type_eb  -- 经办人证件种类(E路通)
    ,replace(replace(t.proxy_papers_number_eb,chr(13),''),chr(10),'') as proxy_papers_number_eb  -- (E路通)经办人证件号码
    ,replace(replace(t.proxy_phone_eb,chr(13),''),chr(10),'') as proxy_phone_eb  -- (E路通)经办人电话号码
    ,replace(replace(t.uuid,chr(13),''),chr(10),'') as uuid  -- 图片ID(E路通)
    ,replace(replace(t.isorganizpaper,chr(13),''),chr(10),'') as isorganizpaper  -- 组织机构代码证是否为第一证件（0否，1是）
    ,replace(replace(t.papers_contact_address,chr(13),''),chr(10),'') as papers_contact_address  -- （营业执照）注册地址
    ,replace(replace(t.papers_principal_name,chr(13),''),chr(10),'') as papers_principal_name  -- 法人姓名（营业执照）
    ,replace(replace(t.papers_papers_number,chr(13),''),chr(10),'') as papers_papers_number  -- （营业执照）证件号码
    ,replace(replace(t.papers_cust_name,chr(13),''),chr(10),'') as papers_cust_name  -- 存款人（营业执照）
    ,replace(replace(t.papers_registerfund,chr(13),''),chr(10),'') as papers_registerfund  -- 注册资金（营业执照）
    ,replace(replace(t.papers_operate_scope,chr(13),''),chr(10),'') as papers_operate_scope  -- （营业执照）经营范围
    ,replace(replace(t.torpa_nat_register_no,chr(13),''),chr(10),'') as torpa_nat_register_no  -- RPA备案国税登记证号
    ,replace(replace(t.torpa_local_register_no,chr(13),''),chr(10),'') as torpa_local_register_no  -- RPA备案地税登记证号
    ,replace(replace(t.is_need_eluton_inchange,chr(13),''),chr(10),'') as is_need_eluton_inchange  -- 是否需要改变（E路通）1-需要，2-不需要
    ,replace(replace(t.torpa_scope,chr(13),''),chr(10),'') as torpa_scope  -- 送RPA备案经营范围
    ,replace(replace(t.torpa_found_date,chr(13),''),chr(10),'') as torpa_found_date  -- 送RPA备案成立日
    ,replace(replace(t.torpa_call_phone,chr(13),''),chr(10),'') as torpa_call_phone  -- 送RPA备案联系电话
    ,replace(replace(t.papers_type_eb,chr(13),''),chr(10),'') as papers_type_eb  -- 第一证件类型
    ,replace(replace(t.registerfund_eb,chr(13),''),chr(10),'') as registerfund_eb  -- 注册资金（送变更人行）
    ,replace(replace(t.istoscope_pb,chr(13),''),chr(10),'') as istoscope_pb  -- 是否变更经营范围（送变更人行）-1是-2否
    ,replace(replace(t.deposit_type_eb,chr(13),''),chr(10),'') as deposit_type_eb  -- （变更送E路通）存款人类别
    ,t.acct_opendt_eb as acct_opendt_eb  -- 客户开户日期
    ,replace(replace(t.trade_type_eb,chr(13),''),chr(10),'') as trade_type_eb  -- 所属行业类型
    ,replace(replace(t.found_date_eb,chr(13),''),chr(10),'') as found_date_eb  -- 成立日期（变更送E路通）
    ,replace(replace(t.perpers_invaldt_eb,chr(13),''),chr(10),'') as perpers_invaldt_eb  -- 营业期限（变更送E路通）
    ,t.principal_invaldt_eb as principal_invaldt_eb  -- 证件生效日期
    ,replace(replace(t.acct_name_eb,chr(13),''),chr(10),'') as acct_name_eb  -- 账户名称（送变更E路通）
    ,replace(replace(t.rpa_people_count,chr(13),''),chr(10),'') as rpa_people_count  -- 人行备案次数
    ,replace(replace(t.rpa_manual_record,chr(13),''),chr(10),'') as rpa_manual_record  -- 是否人工备案：1-是其他-否
    ,replace(replace(t.rpa_max_count,chr(13),''),chr(10),'') as rpa_max_count  -- 配置循环备案最大数次
    ,replace(replace(t.ecfi_papers_t,chr(13),''),chr(10),'') as ecfi_papers_t  -- 原Ecif第二证件值
    ,replace(replace(t.biz_code,chr(13),''),chr(10),'') as biz_code  -- 业务编码
    ,t.start_dt as start_dt  -- 开始日期
    ,t.end_dt as end_dt  -- 结束日期
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark  -- 删除标识
    ,replace(replace(t.e_docid,chr(13),''),chr(10),'') as e_docid  -- 人行查备案返回图片批次号
    ,replace(replace(t.acct_no,chr(13),''),chr(10),'') as acct_no  -- 账号
    ,replace(replace(t.old_approve_no,chr(13),''),chr(10),'') as old_approve_no  -- 原基本存款账户编号
    ,replace(replace(t.doc_id,chr(13),''),chr(10),'') as doc_id  -- 开户/变更时影像批次号
    ,null as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 时间戳
 from ${iol_schema}.scps_bp_rpa_tb t--rpa记录表
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.scps_bp_rpa_tb to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'scps_bp_rpa_tb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);