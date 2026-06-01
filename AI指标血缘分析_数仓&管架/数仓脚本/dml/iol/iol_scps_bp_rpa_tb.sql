/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_rpa_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.scps_bp_rpa_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_rpa_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_rpa_tb_op purge;
drop table ${iol_schema}.scps_bp_rpa_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_rpa_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_rpa_tb where 0=1;

create table ${iol_schema}.scps_bp_rpa_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_rpa_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_rpa_tb_cl(
            id -- 主键
            ,task_id -- 流水号
            ,create_time -- 创建时间
            ,start_time -- 人行备案开始时间
            ,end_time -- 人行备案结束时间
            ,people_fail_reason -- 人行备案失败原因
            ,query_type -- 查询登记类型:1登记2变更
            ,ilegal_relat_company -- 法人关联企业
            ,ilegal_relat_acctno -- 法人关联账户
            ,ilegal_phone_relat_acctno -- 法人同一手机号码关联账户
            ,oprerator_relat_acctno -- 经办人关联账户
            ,oprerator_phone_relat_acctno -- 经办人同一手机号码关联账户
            ,similar_relat_acctno -- 相似关联账户
            ,similar_addr_relat_company -- 相似住所关联企业
            ,is_hanging_acctno -- 是否久悬账户
            ,rec_type -- 备案类型： 0本地备案1异地备案
            ,people_bank_rpa_result -- 人行备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_rpa_result -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_fail_reason -- 广东省企业备案失败原因
            ,des_file_name -- 本地文件路径名
            ,sdi_file_path -- 远程凭证路径
            ,gd_start_time -- 广东备案开始时间
            ,gd_end_time -- 广东备案结束时间
            ,people_bank_query_rpa_result -- 人行信息查询结果 -0未返回、-1正常、-2异常
            ,people_bank_query_rpa_fr -- 人行信息查询失败原因
            ,guangdong_record_rpa_result -- 广东省信息查询结果 -0未返回、-1正常、-2异常
            ,guangdong_record_rpa_fr -- 广东省信息查询失败原因
            ,sz_image_result -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
            ,sz_image_fail_reason -- 深圳影像备案失败原因
            ,sz_start_time -- 深圳影像备案开始时间
            ,sz_end_time -- 深圳影像备案结束时间
            ,is_flag -- 标记是否记录过备案信息 1为是0 为否
            ,pw_file_name -- 存款人查询密码 影像名称
            ,pw_file_path -- 存款人查询密码 影像路径
            ,op_account_num -- 开户许可证编号
            ,gd_notsz_flag -- 深圳开户企业标记 -1是 2否
            ,old_open_licen -- 原开户许可证号
            ,sz_is_have_id -- 是否有证 1有 2没有
            ,arcid -- 案卷表ID
            ,pboc -- 人行查询（0为不查询，1为查询）
            ,ebank -- E路通查询(0为不查询,1为查询)
            ,iselsewhere -- 是否异地(人行；0否，1是)
            ,cust_name -- 存款人名称
            ,deposit_type -- 存款人类别
            ,telephone -- 电话
            ,compay_fin_type -- 法人种类
            ,principal_name -- 法人姓名
            ,principal_papers_type -- 法人证件种类
            ,principal_papers_number -- 法人证件号码
            ,district_code -- 行政区划
            ,register_curr_type -- 注册资金币种
            ,registerfund -- 注册资本
            ,compay_organiz_code -- 组织机构代码
            ,papers_type -- 第一证明文件种类
            ,papers_number -- 第一证明文件编号
            ,papers_type2 -- 第二证明文件种类
            ,papers_number2 -- 第二证明文件编号
            ,nat_register_no -- 国税登记证号
            ,local_register_no -- 地税税登记证号
            ,contact_address -- 地址
            ,operate_scope -- 经营范围
            ,torpa_compay_oragniz_code -- RPA备案上级法人组织机构代码
            ,organiz_code -- RPA备案组织机构代码
            ,papers_kind -- 第一证明文件种类(预受理)
            ,papers_id -- 第一证明文件编号（预受理）
            ,approveno -- 核准号(人行)
            ,distinctcode -- 行政区划
            ,brcode -- 网点号(人行)
            ,imagename -- 图片名
            ,filepath -- 路径
            ,cust_name_eb -- 存款人(E路通)
            ,papers_number_eb -- 营业执照号码(E路通)
            ,principal_name_eb -- 法人姓名(E路通)
            ,principal_papers_type_eb -- 法人证件种类(E路通)
            ,principal_papers_number_eb -- (E路通)法人证件号码
            ,phone_eb -- (E路通)法人电话号码
            ,contact_address_eb -- 地址(E路通)
            ,proxy_name_eb -- 经办人姓名(E路通)
            ,proxy_papers_type_eb -- 经办人证件种类(E路通)
            ,proxy_papers_number_eb -- (E路通)经办人证件号码
            ,proxy_phone_eb -- (E路通)经办人电话号码
            ,uuid -- 图片ID(E路通)
            ,isorganizpaper -- 组织机构代码证是否为第一证件（0否，1是）
            ,papers_contact_address -- （营业执照）注册地址
            ,papers_principal_name -- 法人姓名（营业执照）
            ,papers_papers_number -- （营业执照）证件号码
            ,papers_cust_name -- 存款人（营业执照）
            ,papers_registerfund -- 注册资金（营业执照）
            ,papers_operate_scope -- （营业执照）经营范围
            ,torpa_nat_register_no -- RPA备案国税登记证号
            ,torpa_local_register_no -- RPA备案地税登记证号
            ,is_need_eluton_inchange -- 是否需要改变（E路通）1-需要，2-不需要
            ,torpa_scope -- 送RPA备案经营范围
            ,torpa_found_date -- 送RPA备案成立日
            ,torpa_call_phone -- 送RPA备案联系电话
            ,papers_type_eb -- 第一证件类型
            ,registerfund_eb -- 注册资金（送变更人行）
            ,istoscope_pb -- 是否变更经营范围（送变更人行）-1是-2否
            ,deposit_type_eb -- （变更送E路通）存款人类别
            ,acct_opendt_eb -- 客户开户日期
            ,trade_type_eb -- 所属行业类型
            ,found_date_eb -- 成立日期（变更送E路通）
            ,perpers_invaldt_eb -- 营业期限（变更送E路通）
            ,principal_invaldt_eb -- 证件生效日期
            ,acct_name_eb -- 账户名称（送变更E路通）
            ,rpa_people_count -- 人行备案次数
            ,rpa_manual_record -- 是否人工备案：1-是 其他-否
            ,rpa_max_count -- 配置循环备案最大数次
            ,ecfi_papers_t -- 原Ecif第二证件值
            ,biz_code -- 业务编码
            ,e_docid -- 人行查备案返回图片批次号
            ,acct_no -- 账号
            ,old_approve_no -- 原基本存款账户编号
            ,doc_id -- 开户/变更时影像批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_rpa_tb_op(
            id -- 主键
            ,task_id -- 流水号
            ,create_time -- 创建时间
            ,start_time -- 人行备案开始时间
            ,end_time -- 人行备案结束时间
            ,people_fail_reason -- 人行备案失败原因
            ,query_type -- 查询登记类型:1登记2变更
            ,ilegal_relat_company -- 法人关联企业
            ,ilegal_relat_acctno -- 法人关联账户
            ,ilegal_phone_relat_acctno -- 法人同一手机号码关联账户
            ,oprerator_relat_acctno -- 经办人关联账户
            ,oprerator_phone_relat_acctno -- 经办人同一手机号码关联账户
            ,similar_relat_acctno -- 相似关联账户
            ,similar_addr_relat_company -- 相似住所关联企业
            ,is_hanging_acctno -- 是否久悬账户
            ,rec_type -- 备案类型： 0本地备案1异地备案
            ,people_bank_rpa_result -- 人行备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_rpa_result -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_fail_reason -- 广东省企业备案失败原因
            ,des_file_name -- 本地文件路径名
            ,sdi_file_path -- 远程凭证路径
            ,gd_start_time -- 广东备案开始时间
            ,gd_end_time -- 广东备案结束时间
            ,people_bank_query_rpa_result -- 人行信息查询结果 -0未返回、-1正常、-2异常
            ,people_bank_query_rpa_fr -- 人行信息查询失败原因
            ,guangdong_record_rpa_result -- 广东省信息查询结果 -0未返回、-1正常、-2异常
            ,guangdong_record_rpa_fr -- 广东省信息查询失败原因
            ,sz_image_result -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
            ,sz_image_fail_reason -- 深圳影像备案失败原因
            ,sz_start_time -- 深圳影像备案开始时间
            ,sz_end_time -- 深圳影像备案结束时间
            ,is_flag -- 标记是否记录过备案信息 1为是0 为否
            ,pw_file_name -- 存款人查询密码 影像名称
            ,pw_file_path -- 存款人查询密码 影像路径
            ,op_account_num -- 开户许可证编号
            ,gd_notsz_flag -- 深圳开户企业标记 -1是 2否
            ,old_open_licen -- 原开户许可证号
            ,sz_is_have_id -- 是否有证 1有 2没有
            ,arcid -- 案卷表ID
            ,pboc -- 人行查询（0为不查询，1为查询）
            ,ebank -- E路通查询(0为不查询,1为查询)
            ,iselsewhere -- 是否异地(人行；0否，1是)
            ,cust_name -- 存款人名称
            ,deposit_type -- 存款人类别
            ,telephone -- 电话
            ,compay_fin_type -- 法人种类
            ,principal_name -- 法人姓名
            ,principal_papers_type -- 法人证件种类
            ,principal_papers_number -- 法人证件号码
            ,district_code -- 行政区划
            ,register_curr_type -- 注册资金币种
            ,registerfund -- 注册资本
            ,compay_organiz_code -- 组织机构代码
            ,papers_type -- 第一证明文件种类
            ,papers_number -- 第一证明文件编号
            ,papers_type2 -- 第二证明文件种类
            ,papers_number2 -- 第二证明文件编号
            ,nat_register_no -- 国税登记证号
            ,local_register_no -- 地税税登记证号
            ,contact_address -- 地址
            ,operate_scope -- 经营范围
            ,torpa_compay_oragniz_code -- RPA备案上级法人组织机构代码
            ,organiz_code -- RPA备案组织机构代码
            ,papers_kind -- 第一证明文件种类(预受理)
            ,papers_id -- 第一证明文件编号（预受理）
            ,approveno -- 核准号(人行)
            ,distinctcode -- 行政区划
            ,brcode -- 网点号(人行)
            ,imagename -- 图片名
            ,filepath -- 路径
            ,cust_name_eb -- 存款人(E路通)
            ,papers_number_eb -- 营业执照号码(E路通)
            ,principal_name_eb -- 法人姓名(E路通)
            ,principal_papers_type_eb -- 法人证件种类(E路通)
            ,principal_papers_number_eb -- (E路通)法人证件号码
            ,phone_eb -- (E路通)法人电话号码
            ,contact_address_eb -- 地址(E路通)
            ,proxy_name_eb -- 经办人姓名(E路通)
            ,proxy_papers_type_eb -- 经办人证件种类(E路通)
            ,proxy_papers_number_eb -- (E路通)经办人证件号码
            ,proxy_phone_eb -- (E路通)经办人电话号码
            ,uuid -- 图片ID(E路通)
            ,isorganizpaper -- 组织机构代码证是否为第一证件（0否，1是）
            ,papers_contact_address -- （营业执照）注册地址
            ,papers_principal_name -- 法人姓名（营业执照）
            ,papers_papers_number -- （营业执照）证件号码
            ,papers_cust_name -- 存款人（营业执照）
            ,papers_registerfund -- 注册资金（营业执照）
            ,papers_operate_scope -- （营业执照）经营范围
            ,torpa_nat_register_no -- RPA备案国税登记证号
            ,torpa_local_register_no -- RPA备案地税登记证号
            ,is_need_eluton_inchange -- 是否需要改变（E路通）1-需要，2-不需要
            ,torpa_scope -- 送RPA备案经营范围
            ,torpa_found_date -- 送RPA备案成立日
            ,torpa_call_phone -- 送RPA备案联系电话
            ,papers_type_eb -- 第一证件类型
            ,registerfund_eb -- 注册资金（送变更人行）
            ,istoscope_pb -- 是否变更经营范围（送变更人行）-1是-2否
            ,deposit_type_eb -- （变更送E路通）存款人类别
            ,acct_opendt_eb -- 客户开户日期
            ,trade_type_eb -- 所属行业类型
            ,found_date_eb -- 成立日期（变更送E路通）
            ,perpers_invaldt_eb -- 营业期限（变更送E路通）
            ,principal_invaldt_eb -- 证件生效日期
            ,acct_name_eb -- 账户名称（送变更E路通）
            ,rpa_people_count -- 人行备案次数
            ,rpa_manual_record -- 是否人工备案：1-是 其他-否
            ,rpa_max_count -- 配置循环备案最大数次
            ,ecfi_papers_t -- 原Ecif第二证件值
            ,biz_code -- 业务编码
            ,e_docid -- 人行查备案返回图片批次号
            ,acct_no -- 账号
            ,old_approve_no -- 原基本存款账户编号
            ,doc_id -- 开户/变更时影像批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.task_id, o.task_id) as task_id -- 流水号
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.start_time, o.start_time) as start_time -- 人行备案开始时间
    ,nvl(n.end_time, o.end_time) as end_time -- 人行备案结束时间
    ,nvl(n.people_fail_reason, o.people_fail_reason) as people_fail_reason -- 人行备案失败原因
    ,nvl(n.query_type, o.query_type) as query_type -- 查询登记类型:1登记2变更
    ,nvl(n.ilegal_relat_company, o.ilegal_relat_company) as ilegal_relat_company -- 法人关联企业
    ,nvl(n.ilegal_relat_acctno, o.ilegal_relat_acctno) as ilegal_relat_acctno -- 法人关联账户
    ,nvl(n.ilegal_phone_relat_acctno, o.ilegal_phone_relat_acctno) as ilegal_phone_relat_acctno -- 法人同一手机号码关联账户
    ,nvl(n.oprerator_relat_acctno, o.oprerator_relat_acctno) as oprerator_relat_acctno -- 经办人关联账户
    ,nvl(n.oprerator_phone_relat_acctno, o.oprerator_phone_relat_acctno) as oprerator_phone_relat_acctno -- 经办人同一手机号码关联账户
    ,nvl(n.similar_relat_acctno, o.similar_relat_acctno) as similar_relat_acctno -- 相似关联账户
    ,nvl(n.similar_addr_relat_company, o.similar_addr_relat_company) as similar_addr_relat_company -- 相似住所关联企业
    ,nvl(n.is_hanging_acctno, o.is_hanging_acctno) as is_hanging_acctno -- 是否久悬账户
    ,nvl(n.rec_type, o.rec_type) as rec_type -- 备案类型： 0本地备案1异地备案
    ,nvl(n.people_bank_rpa_result, o.people_bank_rpa_result) as people_bank_rpa_result -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,nvl(n.guangdong_company_rpa_result, o.guangdong_company_rpa_result) as guangdong_company_rpa_result -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,nvl(n.guangdong_company_fail_reason, o.guangdong_company_fail_reason) as guangdong_company_fail_reason -- 广东省企业备案失败原因
    ,nvl(n.des_file_name, o.des_file_name) as des_file_name -- 本地文件路径名
    ,nvl(n.sdi_file_path, o.sdi_file_path) as sdi_file_path -- 远程凭证路径
    ,nvl(n.gd_start_time, o.gd_start_time) as gd_start_time -- 广东备案开始时间
    ,nvl(n.gd_end_time, o.gd_end_time) as gd_end_time -- 广东备案结束时间
    ,nvl(n.people_bank_query_rpa_result, o.people_bank_query_rpa_result) as people_bank_query_rpa_result -- 人行信息查询结果 -0未返回、-1正常、-2异常
    ,nvl(n.people_bank_query_rpa_fr, o.people_bank_query_rpa_fr) as people_bank_query_rpa_fr -- 人行信息查询失败原因
    ,nvl(n.guangdong_record_rpa_result, o.guangdong_record_rpa_result) as guangdong_record_rpa_result -- 广东省信息查询结果 -0未返回、-1正常、-2异常
    ,nvl(n.guangdong_record_rpa_fr, o.guangdong_record_rpa_fr) as guangdong_record_rpa_fr -- 广东省信息查询失败原因
    ,nvl(n.sz_image_result, o.sz_image_result) as sz_image_result -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,nvl(n.sz_image_fail_reason, o.sz_image_fail_reason) as sz_image_fail_reason -- 深圳影像备案失败原因
    ,nvl(n.sz_start_time, o.sz_start_time) as sz_start_time -- 深圳影像备案开始时间
    ,nvl(n.sz_end_time, o.sz_end_time) as sz_end_time -- 深圳影像备案结束时间
    ,nvl(n.is_flag, o.is_flag) as is_flag -- 标记是否记录过备案信息 1为是0 为否
    ,nvl(n.pw_file_name, o.pw_file_name) as pw_file_name -- 存款人查询密码 影像名称
    ,nvl(n.pw_file_path, o.pw_file_path) as pw_file_path -- 存款人查询密码 影像路径
    ,nvl(n.op_account_num, o.op_account_num) as op_account_num -- 开户许可证编号
    ,nvl(n.gd_notsz_flag, o.gd_notsz_flag) as gd_notsz_flag -- 深圳开户企业标记 -1是 2否
    ,nvl(n.old_open_licen, o.old_open_licen) as old_open_licen -- 原开户许可证号
    ,nvl(n.sz_is_have_id, o.sz_is_have_id) as sz_is_have_id -- 是否有证 1有 2没有
    ,nvl(n.arcid, o.arcid) as arcid -- 案卷表ID
    ,nvl(n.pboc, o.pboc) as pboc -- 人行查询（0为不查询，1为查询）
    ,nvl(n.ebank, o.ebank) as ebank -- E路通查询(0为不查询,1为查询)
    ,nvl(n.iselsewhere, o.iselsewhere) as iselsewhere -- 是否异地(人行；0否，1是)
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 存款人名称
    ,nvl(n.deposit_type, o.deposit_type) as deposit_type -- 存款人类别
    ,nvl(n.telephone, o.telephone) as telephone -- 电话
    ,nvl(n.compay_fin_type, o.compay_fin_type) as compay_fin_type -- 法人种类
    ,nvl(n.principal_name, o.principal_name) as principal_name -- 法人姓名
    ,nvl(n.principal_papers_type, o.principal_papers_type) as principal_papers_type -- 法人证件种类
    ,nvl(n.principal_papers_number, o.principal_papers_number) as principal_papers_number -- 法人证件号码
    ,nvl(n.district_code, o.district_code) as district_code -- 行政区划
    ,nvl(n.register_curr_type, o.register_curr_type) as register_curr_type -- 注册资金币种
    ,nvl(n.registerfund, o.registerfund) as registerfund -- 注册资本
    ,nvl(n.compay_organiz_code, o.compay_organiz_code) as compay_organiz_code -- 组织机构代码
    ,nvl(n.papers_type, o.papers_type) as papers_type -- 第一证明文件种类
    ,nvl(n.papers_number, o.papers_number) as papers_number -- 第一证明文件编号
    ,nvl(n.papers_type2, o.papers_type2) as papers_type2 -- 第二证明文件种类
    ,nvl(n.papers_number2, o.papers_number2) as papers_number2 -- 第二证明文件编号
    ,nvl(n.nat_register_no, o.nat_register_no) as nat_register_no -- 国税登记证号
    ,nvl(n.local_register_no, o.local_register_no) as local_register_no -- 地税税登记证号
    ,nvl(n.contact_address, o.contact_address) as contact_address -- 地址
    ,nvl(n.operate_scope, o.operate_scope) as operate_scope -- 经营范围
    ,nvl(n.torpa_compay_oragniz_code, o.torpa_compay_oragniz_code) as torpa_compay_oragniz_code -- RPA备案上级法人组织机构代码
    ,nvl(n.organiz_code, o.organiz_code) as organiz_code -- RPA备案组织机构代码
    ,nvl(n.papers_kind, o.papers_kind) as papers_kind -- 第一证明文件种类(预受理)
    ,nvl(n.papers_id, o.papers_id) as papers_id -- 第一证明文件编号（预受理）
    ,nvl(n.approveno, o.approveno) as approveno -- 核准号(人行)
    ,nvl(n.distinctcode, o.distinctcode) as distinctcode -- 行政区划
    ,nvl(n.brcode, o.brcode) as brcode -- 网点号(人行)
    ,nvl(n.imagename, o.imagename) as imagename -- 图片名
    ,nvl(n.filepath, o.filepath) as filepath -- 路径
    ,nvl(n.cust_name_eb, o.cust_name_eb) as cust_name_eb -- 存款人(E路通)
    ,nvl(n.papers_number_eb, o.papers_number_eb) as papers_number_eb -- 营业执照号码(E路通)
    ,nvl(n.principal_name_eb, o.principal_name_eb) as principal_name_eb -- 法人姓名(E路通)
    ,nvl(n.principal_papers_type_eb, o.principal_papers_type_eb) as principal_papers_type_eb -- 法人证件种类(E路通)
    ,nvl(n.principal_papers_number_eb, o.principal_papers_number_eb) as principal_papers_number_eb -- (E路通)法人证件号码
    ,nvl(n.phone_eb, o.phone_eb) as phone_eb -- (E路通)法人电话号码
    ,nvl(n.contact_address_eb, o.contact_address_eb) as contact_address_eb -- 地址(E路通)
    ,nvl(n.proxy_name_eb, o.proxy_name_eb) as proxy_name_eb -- 经办人姓名(E路通)
    ,nvl(n.proxy_papers_type_eb, o.proxy_papers_type_eb) as proxy_papers_type_eb -- 经办人证件种类(E路通)
    ,nvl(n.proxy_papers_number_eb, o.proxy_papers_number_eb) as proxy_papers_number_eb -- (E路通)经办人证件号码
    ,nvl(n.proxy_phone_eb, o.proxy_phone_eb) as proxy_phone_eb -- (E路通)经办人电话号码
    ,nvl(n.uuid, o.uuid) as uuid -- 图片ID(E路通)
    ,nvl(n.isorganizpaper, o.isorganizpaper) as isorganizpaper -- 组织机构代码证是否为第一证件（0否，1是）
    ,nvl(n.papers_contact_address, o.papers_contact_address) as papers_contact_address -- （营业执照）注册地址
    ,nvl(n.papers_principal_name, o.papers_principal_name) as papers_principal_name -- 法人姓名（营业执照）
    ,nvl(n.papers_papers_number, o.papers_papers_number) as papers_papers_number -- （营业执照）证件号码
    ,nvl(n.papers_cust_name, o.papers_cust_name) as papers_cust_name -- 存款人（营业执照）
    ,nvl(n.papers_registerfund, o.papers_registerfund) as papers_registerfund -- 注册资金（营业执照）
    ,nvl(n.papers_operate_scope, o.papers_operate_scope) as papers_operate_scope -- （营业执照）经营范围
    ,nvl(n.torpa_nat_register_no, o.torpa_nat_register_no) as torpa_nat_register_no -- RPA备案国税登记证号
    ,nvl(n.torpa_local_register_no, o.torpa_local_register_no) as torpa_local_register_no -- RPA备案地税登记证号
    ,nvl(n.is_need_eluton_inchange, o.is_need_eluton_inchange) as is_need_eluton_inchange -- 是否需要改变（E路通）1-需要，2-不需要
    ,nvl(n.torpa_scope, o.torpa_scope) as torpa_scope -- 送RPA备案经营范围
    ,nvl(n.torpa_found_date, o.torpa_found_date) as torpa_found_date -- 送RPA备案成立日
    ,nvl(n.torpa_call_phone, o.torpa_call_phone) as torpa_call_phone -- 送RPA备案联系电话
    ,nvl(n.papers_type_eb, o.papers_type_eb) as papers_type_eb -- 第一证件类型
    ,nvl(n.registerfund_eb, o.registerfund_eb) as registerfund_eb -- 注册资金（送变更人行）
    ,nvl(n.istoscope_pb, o.istoscope_pb) as istoscope_pb -- 是否变更经营范围（送变更人行）-1是-2否
    ,nvl(n.deposit_type_eb, o.deposit_type_eb) as deposit_type_eb -- （变更送E路通）存款人类别
    ,nvl(n.acct_opendt_eb, o.acct_opendt_eb) as acct_opendt_eb -- 客户开户日期
    ,nvl(n.trade_type_eb, o.trade_type_eb) as trade_type_eb -- 所属行业类型
    ,nvl(n.found_date_eb, o.found_date_eb) as found_date_eb -- 成立日期（变更送E路通）
    ,nvl(n.perpers_invaldt_eb, o.perpers_invaldt_eb) as perpers_invaldt_eb -- 营业期限（变更送E路通）
    ,nvl(n.principal_invaldt_eb, o.principal_invaldt_eb) as principal_invaldt_eb -- 证件生效日期
    ,nvl(n.acct_name_eb, o.acct_name_eb) as acct_name_eb -- 账户名称（送变更E路通）
    ,nvl(n.rpa_people_count, o.rpa_people_count) as rpa_people_count -- 人行备案次数
    ,nvl(n.rpa_manual_record, o.rpa_manual_record) as rpa_manual_record -- 是否人工备案：1-是 其他-否
    ,nvl(n.rpa_max_count, o.rpa_max_count) as rpa_max_count -- 配置循环备案最大数次
    ,nvl(n.ecfi_papers_t, o.ecfi_papers_t) as ecfi_papers_t -- 原Ecif第二证件值
    ,nvl(n.biz_code, o.biz_code) as biz_code -- 业务编码
    ,nvl(n.e_docid, o.e_docid) as e_docid -- 人行查备案返回图片批次号
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 账号
    ,nvl(n.old_approve_no, o.old_approve_no) as old_approve_no -- 原基本存款账户编号
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 开户/变更时影像批次号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_rpa_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_rpa_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.task_id <> n.task_id
        or o.create_time <> n.create_time
        or o.start_time <> n.start_time
        or o.end_time <> n.end_time
        or o.people_fail_reason <> n.people_fail_reason
        or o.query_type <> n.query_type
        or o.ilegal_relat_company <> n.ilegal_relat_company
        or o.ilegal_relat_acctno <> n.ilegal_relat_acctno
        or o.ilegal_phone_relat_acctno <> n.ilegal_phone_relat_acctno
        or o.oprerator_relat_acctno <> n.oprerator_relat_acctno
        or o.oprerator_phone_relat_acctno <> n.oprerator_phone_relat_acctno
        or o.similar_relat_acctno <> n.similar_relat_acctno
        or o.similar_addr_relat_company <> n.similar_addr_relat_company
        or o.is_hanging_acctno <> n.is_hanging_acctno
        or o.rec_type <> n.rec_type
        or o.people_bank_rpa_result <> n.people_bank_rpa_result
        or o.guangdong_company_rpa_result <> n.guangdong_company_rpa_result
        or o.guangdong_company_fail_reason <> n.guangdong_company_fail_reason
        or o.des_file_name <> n.des_file_name
        or o.sdi_file_path <> n.sdi_file_path
        or o.gd_start_time <> n.gd_start_time
        or o.gd_end_time <> n.gd_end_time
        or o.people_bank_query_rpa_result <> n.people_bank_query_rpa_result
        or o.people_bank_query_rpa_fr <> n.people_bank_query_rpa_fr
        or o.guangdong_record_rpa_result <> n.guangdong_record_rpa_result
        or o.guangdong_record_rpa_fr <> n.guangdong_record_rpa_fr
        or o.sz_image_result <> n.sz_image_result
        or o.sz_image_fail_reason <> n.sz_image_fail_reason
        or o.sz_start_time <> n.sz_start_time
        or o.sz_end_time <> n.sz_end_time
        or o.is_flag <> n.is_flag
        or o.pw_file_name <> n.pw_file_name
        or o.pw_file_path <> n.pw_file_path
        or o.op_account_num <> n.op_account_num
        or o.gd_notsz_flag <> n.gd_notsz_flag
        or o.old_open_licen <> n.old_open_licen
        or o.sz_is_have_id <> n.sz_is_have_id
        or o.arcid <> n.arcid
        or o.pboc <> n.pboc
        or o.ebank <> n.ebank
        or o.iselsewhere <> n.iselsewhere
        or o.cust_name <> n.cust_name
        or o.deposit_type <> n.deposit_type
        or o.telephone <> n.telephone
        or o.compay_fin_type <> n.compay_fin_type
        or o.principal_name <> n.principal_name
        or o.principal_papers_type <> n.principal_papers_type
        or o.principal_papers_number <> n.principal_papers_number
        or o.district_code <> n.district_code
        or o.register_curr_type <> n.register_curr_type
        or o.registerfund <> n.registerfund
        or o.compay_organiz_code <> n.compay_organiz_code
        or o.papers_type <> n.papers_type
        or o.papers_number <> n.papers_number
        or o.papers_type2 <> n.papers_type2
        or o.papers_number2 <> n.papers_number2
        or o.nat_register_no <> n.nat_register_no
        or o.local_register_no <> n.local_register_no
        or o.contact_address <> n.contact_address
        or o.operate_scope <> n.operate_scope
        or o.torpa_compay_oragniz_code <> n.torpa_compay_oragniz_code
        or o.organiz_code <> n.organiz_code
        or o.papers_kind <> n.papers_kind
        or o.papers_id <> n.papers_id
        or o.approveno <> n.approveno
        or o.distinctcode <> n.distinctcode
        or o.brcode <> n.brcode
        or o.imagename <> n.imagename
        or o.filepath <> n.filepath
        or o.cust_name_eb <> n.cust_name_eb
        or o.papers_number_eb <> n.papers_number_eb
        or o.principal_name_eb <> n.principal_name_eb
        or o.principal_papers_type_eb <> n.principal_papers_type_eb
        or o.principal_papers_number_eb <> n.principal_papers_number_eb
        or o.phone_eb <> n.phone_eb
        or o.contact_address_eb <> n.contact_address_eb
        or o.proxy_name_eb <> n.proxy_name_eb
        or o.proxy_papers_type_eb <> n.proxy_papers_type_eb
        or o.proxy_papers_number_eb <> n.proxy_papers_number_eb
        or o.proxy_phone_eb <> n.proxy_phone_eb
        or o.uuid <> n.uuid
        or o.isorganizpaper <> n.isorganizpaper
        or o.papers_contact_address <> n.papers_contact_address
        or o.papers_principal_name <> n.papers_principal_name
        or o.papers_papers_number <> n.papers_papers_number
        or o.papers_cust_name <> n.papers_cust_name
        or o.papers_registerfund <> n.papers_registerfund
        or o.papers_operate_scope <> n.papers_operate_scope
        or o.torpa_nat_register_no <> n.torpa_nat_register_no
        or o.torpa_local_register_no <> n.torpa_local_register_no
        or o.is_need_eluton_inchange <> n.is_need_eluton_inchange
        or o.torpa_scope <> n.torpa_scope
        or o.torpa_found_date <> n.torpa_found_date
        or o.torpa_call_phone <> n.torpa_call_phone
        or o.papers_type_eb <> n.papers_type_eb
        or o.registerfund_eb <> n.registerfund_eb
        or o.istoscope_pb <> n.istoscope_pb
        or o.deposit_type_eb <> n.deposit_type_eb
        or o.acct_opendt_eb <> n.acct_opendt_eb
        or o.trade_type_eb <> n.trade_type_eb
        or o.found_date_eb <> n.found_date_eb
        or o.perpers_invaldt_eb <> n.perpers_invaldt_eb
        or o.principal_invaldt_eb <> n.principal_invaldt_eb
        or o.acct_name_eb <> n.acct_name_eb
        or o.rpa_people_count <> n.rpa_people_count
        or o.rpa_manual_record <> n.rpa_manual_record
        or o.rpa_max_count <> n.rpa_max_count
        or o.ecfi_papers_t <> n.ecfi_papers_t
        or o.biz_code <> n.biz_code
        or o.e_docid <> n.e_docid
        or o.acct_no <> n.acct_no
        or o.old_approve_no <> n.old_approve_no
        or o.doc_id <> n.doc_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_rpa_tb_cl(
            id -- 主键
            ,task_id -- 流水号
            ,create_time -- 创建时间
            ,start_time -- 人行备案开始时间
            ,end_time -- 人行备案结束时间
            ,people_fail_reason -- 人行备案失败原因
            ,query_type -- 查询登记类型:1登记2变更
            ,ilegal_relat_company -- 法人关联企业
            ,ilegal_relat_acctno -- 法人关联账户
            ,ilegal_phone_relat_acctno -- 法人同一手机号码关联账户
            ,oprerator_relat_acctno -- 经办人关联账户
            ,oprerator_phone_relat_acctno -- 经办人同一手机号码关联账户
            ,similar_relat_acctno -- 相似关联账户
            ,similar_addr_relat_company -- 相似住所关联企业
            ,is_hanging_acctno -- 是否久悬账户
            ,rec_type -- 备案类型： 0本地备案1异地备案
            ,people_bank_rpa_result -- 人行备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_rpa_result -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_fail_reason -- 广东省企业备案失败原因
            ,des_file_name -- 本地文件路径名
            ,sdi_file_path -- 远程凭证路径
            ,gd_start_time -- 广东备案开始时间
            ,gd_end_time -- 广东备案结束时间
            ,people_bank_query_rpa_result -- 人行信息查询结果 -0未返回、-1正常、-2异常
            ,people_bank_query_rpa_fr -- 人行信息查询失败原因
            ,guangdong_record_rpa_result -- 广东省信息查询结果 -0未返回、-1正常、-2异常
            ,guangdong_record_rpa_fr -- 广东省信息查询失败原因
            ,sz_image_result -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
            ,sz_image_fail_reason -- 深圳影像备案失败原因
            ,sz_start_time -- 深圳影像备案开始时间
            ,sz_end_time -- 深圳影像备案结束时间
            ,is_flag -- 标记是否记录过备案信息 1为是0 为否
            ,pw_file_name -- 存款人查询密码 影像名称
            ,pw_file_path -- 存款人查询密码 影像路径
            ,op_account_num -- 开户许可证编号
            ,gd_notsz_flag -- 深圳开户企业标记 -1是 2否
            ,old_open_licen -- 原开户许可证号
            ,sz_is_have_id -- 是否有证 1有 2没有
            ,arcid -- 案卷表ID
            ,pboc -- 人行查询（0为不查询，1为查询）
            ,ebank -- E路通查询(0为不查询,1为查询)
            ,iselsewhere -- 是否异地(人行；0否，1是)
            ,cust_name -- 存款人名称
            ,deposit_type -- 存款人类别
            ,telephone -- 电话
            ,compay_fin_type -- 法人种类
            ,principal_name -- 法人姓名
            ,principal_papers_type -- 法人证件种类
            ,principal_papers_number -- 法人证件号码
            ,district_code -- 行政区划
            ,register_curr_type -- 注册资金币种
            ,registerfund -- 注册资本
            ,compay_organiz_code -- 组织机构代码
            ,papers_type -- 第一证明文件种类
            ,papers_number -- 第一证明文件编号
            ,papers_type2 -- 第二证明文件种类
            ,papers_number2 -- 第二证明文件编号
            ,nat_register_no -- 国税登记证号
            ,local_register_no -- 地税税登记证号
            ,contact_address -- 地址
            ,operate_scope -- 经营范围
            ,torpa_compay_oragniz_code -- RPA备案上级法人组织机构代码
            ,organiz_code -- RPA备案组织机构代码
            ,papers_kind -- 第一证明文件种类(预受理)
            ,papers_id -- 第一证明文件编号（预受理）
            ,approveno -- 核准号(人行)
            ,distinctcode -- 行政区划
            ,brcode -- 网点号(人行)
            ,imagename -- 图片名
            ,filepath -- 路径
            ,cust_name_eb -- 存款人(E路通)
            ,papers_number_eb -- 营业执照号码(E路通)
            ,principal_name_eb -- 法人姓名(E路通)
            ,principal_papers_type_eb -- 法人证件种类(E路通)
            ,principal_papers_number_eb -- (E路通)法人证件号码
            ,phone_eb -- (E路通)法人电话号码
            ,contact_address_eb -- 地址(E路通)
            ,proxy_name_eb -- 经办人姓名(E路通)
            ,proxy_papers_type_eb -- 经办人证件种类(E路通)
            ,proxy_papers_number_eb -- (E路通)经办人证件号码
            ,proxy_phone_eb -- (E路通)经办人电话号码
            ,uuid -- 图片ID(E路通)
            ,isorganizpaper -- 组织机构代码证是否为第一证件（0否，1是）
            ,papers_contact_address -- （营业执照）注册地址
            ,papers_principal_name -- 法人姓名（营业执照）
            ,papers_papers_number -- （营业执照）证件号码
            ,papers_cust_name -- 存款人（营业执照）
            ,papers_registerfund -- 注册资金（营业执照）
            ,papers_operate_scope -- （营业执照）经营范围
            ,torpa_nat_register_no -- RPA备案国税登记证号
            ,torpa_local_register_no -- RPA备案地税登记证号
            ,is_need_eluton_inchange -- 是否需要改变（E路通）1-需要，2-不需要
            ,torpa_scope -- 送RPA备案经营范围
            ,torpa_found_date -- 送RPA备案成立日
            ,torpa_call_phone -- 送RPA备案联系电话
            ,papers_type_eb -- 第一证件类型
            ,registerfund_eb -- 注册资金（送变更人行）
            ,istoscope_pb -- 是否变更经营范围（送变更人行）-1是-2否
            ,deposit_type_eb -- （变更送E路通）存款人类别
            ,acct_opendt_eb -- 客户开户日期
            ,trade_type_eb -- 所属行业类型
            ,found_date_eb -- 成立日期（变更送E路通）
            ,perpers_invaldt_eb -- 营业期限（变更送E路通）
            ,principal_invaldt_eb -- 证件生效日期
            ,acct_name_eb -- 账户名称（送变更E路通）
            ,rpa_people_count -- 人行备案次数
            ,rpa_manual_record -- 是否人工备案：1-是 其他-否
            ,rpa_max_count -- 配置循环备案最大数次
            ,ecfi_papers_t -- 原Ecif第二证件值
            ,biz_code -- 业务编码
            ,e_docid -- 人行查备案返回图片批次号
            ,acct_no -- 账号
            ,old_approve_no -- 原基本存款账户编号
            ,doc_id -- 开户/变更时影像批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_rpa_tb_op(
            id -- 主键
            ,task_id -- 流水号
            ,create_time -- 创建时间
            ,start_time -- 人行备案开始时间
            ,end_time -- 人行备案结束时间
            ,people_fail_reason -- 人行备案失败原因
            ,query_type -- 查询登记类型:1登记2变更
            ,ilegal_relat_company -- 法人关联企业
            ,ilegal_relat_acctno -- 法人关联账户
            ,ilegal_phone_relat_acctno -- 法人同一手机号码关联账户
            ,oprerator_relat_acctno -- 经办人关联账户
            ,oprerator_phone_relat_acctno -- 经办人同一手机号码关联账户
            ,similar_relat_acctno -- 相似关联账户
            ,similar_addr_relat_company -- 相似住所关联企业
            ,is_hanging_acctno -- 是否久悬账户
            ,rec_type -- 备案类型： 0本地备案1异地备案
            ,people_bank_rpa_result -- 人行备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_rpa_result -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
            ,guangdong_company_fail_reason -- 广东省企业备案失败原因
            ,des_file_name -- 本地文件路径名
            ,sdi_file_path -- 远程凭证路径
            ,gd_start_time -- 广东备案开始时间
            ,gd_end_time -- 广东备案结束时间
            ,people_bank_query_rpa_result -- 人行信息查询结果 -0未返回、-1正常、-2异常
            ,people_bank_query_rpa_fr -- 人行信息查询失败原因
            ,guangdong_record_rpa_result -- 广东省信息查询结果 -0未返回、-1正常、-2异常
            ,guangdong_record_rpa_fr -- 广东省信息查询失败原因
            ,sz_image_result -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
            ,sz_image_fail_reason -- 深圳影像备案失败原因
            ,sz_start_time -- 深圳影像备案开始时间
            ,sz_end_time -- 深圳影像备案结束时间
            ,is_flag -- 标记是否记录过备案信息 1为是0 为否
            ,pw_file_name -- 存款人查询密码 影像名称
            ,pw_file_path -- 存款人查询密码 影像路径
            ,op_account_num -- 开户许可证编号
            ,gd_notsz_flag -- 深圳开户企业标记 -1是 2否
            ,old_open_licen -- 原开户许可证号
            ,sz_is_have_id -- 是否有证 1有 2没有
            ,arcid -- 案卷表ID
            ,pboc -- 人行查询（0为不查询，1为查询）
            ,ebank -- E路通查询(0为不查询,1为查询)
            ,iselsewhere -- 是否异地(人行；0否，1是)
            ,cust_name -- 存款人名称
            ,deposit_type -- 存款人类别
            ,telephone -- 电话
            ,compay_fin_type -- 法人种类
            ,principal_name -- 法人姓名
            ,principal_papers_type -- 法人证件种类
            ,principal_papers_number -- 法人证件号码
            ,district_code -- 行政区划
            ,register_curr_type -- 注册资金币种
            ,registerfund -- 注册资本
            ,compay_organiz_code -- 组织机构代码
            ,papers_type -- 第一证明文件种类
            ,papers_number -- 第一证明文件编号
            ,papers_type2 -- 第二证明文件种类
            ,papers_number2 -- 第二证明文件编号
            ,nat_register_no -- 国税登记证号
            ,local_register_no -- 地税税登记证号
            ,contact_address -- 地址
            ,operate_scope -- 经营范围
            ,torpa_compay_oragniz_code -- RPA备案上级法人组织机构代码
            ,organiz_code -- RPA备案组织机构代码
            ,papers_kind -- 第一证明文件种类(预受理)
            ,papers_id -- 第一证明文件编号（预受理）
            ,approveno -- 核准号(人行)
            ,distinctcode -- 行政区划
            ,brcode -- 网点号(人行)
            ,imagename -- 图片名
            ,filepath -- 路径
            ,cust_name_eb -- 存款人(E路通)
            ,papers_number_eb -- 营业执照号码(E路通)
            ,principal_name_eb -- 法人姓名(E路通)
            ,principal_papers_type_eb -- 法人证件种类(E路通)
            ,principal_papers_number_eb -- (E路通)法人证件号码
            ,phone_eb -- (E路通)法人电话号码
            ,contact_address_eb -- 地址(E路通)
            ,proxy_name_eb -- 经办人姓名(E路通)
            ,proxy_papers_type_eb -- 经办人证件种类(E路通)
            ,proxy_papers_number_eb -- (E路通)经办人证件号码
            ,proxy_phone_eb -- (E路通)经办人电话号码
            ,uuid -- 图片ID(E路通)
            ,isorganizpaper -- 组织机构代码证是否为第一证件（0否，1是）
            ,papers_contact_address -- （营业执照）注册地址
            ,papers_principal_name -- 法人姓名（营业执照）
            ,papers_papers_number -- （营业执照）证件号码
            ,papers_cust_name -- 存款人（营业执照）
            ,papers_registerfund -- 注册资金（营业执照）
            ,papers_operate_scope -- （营业执照）经营范围
            ,torpa_nat_register_no -- RPA备案国税登记证号
            ,torpa_local_register_no -- RPA备案地税登记证号
            ,is_need_eluton_inchange -- 是否需要改变（E路通）1-需要，2-不需要
            ,torpa_scope -- 送RPA备案经营范围
            ,torpa_found_date -- 送RPA备案成立日
            ,torpa_call_phone -- 送RPA备案联系电话
            ,papers_type_eb -- 第一证件类型
            ,registerfund_eb -- 注册资金（送变更人行）
            ,istoscope_pb -- 是否变更经营范围（送变更人行）-1是-2否
            ,deposit_type_eb -- （变更送E路通）存款人类别
            ,acct_opendt_eb -- 客户开户日期
            ,trade_type_eb -- 所属行业类型
            ,found_date_eb -- 成立日期（变更送E路通）
            ,perpers_invaldt_eb -- 营业期限（变更送E路通）
            ,principal_invaldt_eb -- 证件生效日期
            ,acct_name_eb -- 账户名称（送变更E路通）
            ,rpa_people_count -- 人行备案次数
            ,rpa_manual_record -- 是否人工备案：1-是 其他-否
            ,rpa_max_count -- 配置循环备案最大数次
            ,ecfi_papers_t -- 原Ecif第二证件值
            ,biz_code -- 业务编码
            ,e_docid -- 人行查备案返回图片批次号
            ,acct_no -- 账号
            ,old_approve_no -- 原基本存款账户编号
            ,doc_id -- 开户/变更时影像批次号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.task_id -- 流水号
    ,o.create_time -- 创建时间
    ,o.start_time -- 人行备案开始时间
    ,o.end_time -- 人行备案结束时间
    ,o.people_fail_reason -- 人行备案失败原因
    ,o.query_type -- 查询登记类型:1登记2变更
    ,o.ilegal_relat_company -- 法人关联企业
    ,o.ilegal_relat_acctno -- 法人关联账户
    ,o.ilegal_phone_relat_acctno -- 法人同一手机号码关联账户
    ,o.oprerator_relat_acctno -- 经办人关联账户
    ,o.oprerator_phone_relat_acctno -- 经办人同一手机号码关联账户
    ,o.similar_relat_acctno -- 相似关联账户
    ,o.similar_addr_relat_company -- 相似住所关联企业
    ,o.is_hanging_acctno -- 是否久悬账户
    ,o.rec_type -- 备案类型： 0本地备案1异地备案
    ,o.people_bank_rpa_result -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,o.guangdong_company_rpa_result -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,o.guangdong_company_fail_reason -- 广东省企业备案失败原因
    ,o.des_file_name -- 本地文件路径名
    ,o.sdi_file_path -- 远程凭证路径
    ,o.gd_start_time -- 广东备案开始时间
    ,o.gd_end_time -- 广东备案结束时间
    ,o.people_bank_query_rpa_result -- 人行信息查询结果 -0未返回、-1正常、-2异常
    ,o.people_bank_query_rpa_fr -- 人行信息查询失败原因
    ,o.guangdong_record_rpa_result -- 广东省信息查询结果 -0未返回、-1正常、-2异常
    ,o.guangdong_record_rpa_fr -- 广东省信息查询失败原因
    ,o.sz_image_result -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,o.sz_image_fail_reason -- 深圳影像备案失败原因
    ,o.sz_start_time -- 深圳影像备案开始时间
    ,o.sz_end_time -- 深圳影像备案结束时间
    ,o.is_flag -- 标记是否记录过备案信息 1为是0 为否
    ,o.pw_file_name -- 存款人查询密码 影像名称
    ,o.pw_file_path -- 存款人查询密码 影像路径
    ,o.op_account_num -- 开户许可证编号
    ,o.gd_notsz_flag -- 深圳开户企业标记 -1是 2否
    ,o.old_open_licen -- 原开户许可证号
    ,o.sz_is_have_id -- 是否有证 1有 2没有
    ,o.arcid -- 案卷表ID
    ,o.pboc -- 人行查询（0为不查询，1为查询）
    ,o.ebank -- E路通查询(0为不查询,1为查询)
    ,o.iselsewhere -- 是否异地(人行；0否，1是)
    ,o.cust_name -- 存款人名称
    ,o.deposit_type -- 存款人类别
    ,o.telephone -- 电话
    ,o.compay_fin_type -- 法人种类
    ,o.principal_name -- 法人姓名
    ,o.principal_papers_type -- 法人证件种类
    ,o.principal_papers_number -- 法人证件号码
    ,o.district_code -- 行政区划
    ,o.register_curr_type -- 注册资金币种
    ,o.registerfund -- 注册资本
    ,o.compay_organiz_code -- 组织机构代码
    ,o.papers_type -- 第一证明文件种类
    ,o.papers_number -- 第一证明文件编号
    ,o.papers_type2 -- 第二证明文件种类
    ,o.papers_number2 -- 第二证明文件编号
    ,o.nat_register_no -- 国税登记证号
    ,o.local_register_no -- 地税税登记证号
    ,o.contact_address -- 地址
    ,o.operate_scope -- 经营范围
    ,o.torpa_compay_oragniz_code -- RPA备案上级法人组织机构代码
    ,o.organiz_code -- RPA备案组织机构代码
    ,o.papers_kind -- 第一证明文件种类(预受理)
    ,o.papers_id -- 第一证明文件编号（预受理）
    ,o.approveno -- 核准号(人行)
    ,o.distinctcode -- 行政区划
    ,o.brcode -- 网点号(人行)
    ,o.imagename -- 图片名
    ,o.filepath -- 路径
    ,o.cust_name_eb -- 存款人(E路通)
    ,o.papers_number_eb -- 营业执照号码(E路通)
    ,o.principal_name_eb -- 法人姓名(E路通)
    ,o.principal_papers_type_eb -- 法人证件种类(E路通)
    ,o.principal_papers_number_eb -- (E路通)法人证件号码
    ,o.phone_eb -- (E路通)法人电话号码
    ,o.contact_address_eb -- 地址(E路通)
    ,o.proxy_name_eb -- 经办人姓名(E路通)
    ,o.proxy_papers_type_eb -- 经办人证件种类(E路通)
    ,o.proxy_papers_number_eb -- (E路通)经办人证件号码
    ,o.proxy_phone_eb -- (E路通)经办人电话号码
    ,o.uuid -- 图片ID(E路通)
    ,o.isorganizpaper -- 组织机构代码证是否为第一证件（0否，1是）
    ,o.papers_contact_address -- （营业执照）注册地址
    ,o.papers_principal_name -- 法人姓名（营业执照）
    ,o.papers_papers_number -- （营业执照）证件号码
    ,o.papers_cust_name -- 存款人（营业执照）
    ,o.papers_registerfund -- 注册资金（营业执照）
    ,o.papers_operate_scope -- （营业执照）经营范围
    ,o.torpa_nat_register_no -- RPA备案国税登记证号
    ,o.torpa_local_register_no -- RPA备案地税登记证号
    ,o.is_need_eluton_inchange -- 是否需要改变（E路通）1-需要，2-不需要
    ,o.torpa_scope -- 送RPA备案经营范围
    ,o.torpa_found_date -- 送RPA备案成立日
    ,o.torpa_call_phone -- 送RPA备案联系电话
    ,o.papers_type_eb -- 第一证件类型
    ,o.registerfund_eb -- 注册资金（送变更人行）
    ,o.istoscope_pb -- 是否变更经营范围（送变更人行）-1是-2否
    ,o.deposit_type_eb -- （变更送E路通）存款人类别
    ,o.acct_opendt_eb -- 客户开户日期
    ,o.trade_type_eb -- 所属行业类型
    ,o.found_date_eb -- 成立日期（变更送E路通）
    ,o.perpers_invaldt_eb -- 营业期限（变更送E路通）
    ,o.principal_invaldt_eb -- 证件生效日期
    ,o.acct_name_eb -- 账户名称（送变更E路通）
    ,o.rpa_people_count -- 人行备案次数
    ,o.rpa_manual_record -- 是否人工备案：1-是 其他-否
    ,o.rpa_max_count -- 配置循环备案最大数次
    ,o.ecfi_papers_t -- 原Ecif第二证件值
    ,o.biz_code -- 业务编码
    ,o.e_docid -- 人行查备案返回图片批次号
    ,o.acct_no -- 账号
    ,o.old_approve_no -- 原基本存款账户编号
    ,o.doc_id -- 开户/变更时影像批次号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_rpa_tb_bk o
    left join ${iol_schema}.scps_bp_rpa_tb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_rpa_tb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_rpa_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_rpa_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_rpa_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_rpa_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_rpa_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_rpa_tb_cl;
alter table ${iol_schema}.scps_bp_rpa_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_rpa_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_rpa_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_rpa_tb_op purge;
drop table ${iol_schema}.scps_bp_rpa_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_rpa_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_rpa_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
