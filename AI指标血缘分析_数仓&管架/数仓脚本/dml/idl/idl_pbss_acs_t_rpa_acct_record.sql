/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pbss_acs_t_rpa_acct_record
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.pbss_acs_t_rpa_acct_record drop partition p_${last_date};
alter table ${idl_schema}.pbss_acs_t_rpa_acct_record drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pbss_acs_t_rpa_acct_record add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pbss_acs_t_rpa_acct_record (
    etl_dt  -- 数据日期
    ,id  -- id
    ,scan_seq_no  -- 流水号
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
    ,rec_type  -- 备案类型： 0本地备案1异地备案
    ,people_bank_rpa_result  -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,guangdong_company_rpa_result  -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,guangdong_company_fail_reason  -- 广东省企业备案失败原因
    ,des_file_name  -- 本地文件路径名
    ,sdi_file_path  -- 远程凭证路径
    ,gd_start_time  -- 广东备案开始时间
    ,gd_end_time  -- 广东备案结束时间
    ,people_bank_query_rpa_result  -- 人行信息查询结果 -0未返回、-1正常、-2异常
    ,people_bank_query_rpa_fr  -- 人行信息查询失败原因
    ,guangdong_record_rpa_result  -- 广东省信息查询结果 -0未返回、-1正常、-2异常
    ,guangdong_record_rpa_fr  -- 广东省信息查询失败原因
    ,sz_image_result  -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,sz_image_fail_reason  -- 深圳影像备案失败原因
    ,sz_start_time  -- 深圳影像备案开始时间
    ,sz_end_time  -- 深圳影像备案结束时间
    ,is_flag  -- 标记是否记录过备案信息 1为是0 为否
    ,pw_file_name  -- 存款人查询密码 影像名称
    ,pw_file_path  -- 存款人查询密码 影像路径
    ,op_account_num  -- 开户许可证编号
    ,gd_notsz_flag  -- 深圳开户企业标记 -1是 2否
    ,old_open_licen  -- 原开户许可证号
    ,sz_is_have_id  -- 是否有证 1有 2没有
    ,arcid  -- 案卷表id
    ,pboc  -- 人行查询（0为不查询，1为查询）
    ,ebank  -- e路通查询(0为不查询,1为查询)
    ,iselsewhere  -- 是否异地(人行；0否，1是)
    ,cust_name  -- 存款人名称
    ,deposit_type  -- 存款人类别
    ,telephone  -- 电话
    ,compay_fin_type  -- 法人种类
    ,principal_name  -- 法人姓名
    ,principal_papers_type  -- 法人证件种类
    ,principal_papers_number  -- 法人证件号码
    ,district_code  -- 注册地区代码
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
    ,torpa_compay_oragniz_code  -- rpa备案上级法人组织机构代码
    ,organiz_code  -- rpa备案组织机构代码
    ,papers_kind  -- 第一证明文件种类(预受理)
    ,papers_id  -- 第一证明文件编号（预受理）
    ,approveno  -- 核准号(人行)
    ,distinctcode  -- 地区代码(人行)
    ,brcode  -- 网点号(人行)
    ,imagename  -- 图片名
    ,filepath  -- 路径
    ,cust_name_eb  -- 存款人(e路通)
    ,papers_number_eb  -- 营业执照号码(e路通)
    ,principal_name_eb  -- 法人姓名(e路通)
    ,principal_papers_type_eb  -- 法人证件种类(e路通)
    ,principal_papers_number_eb  -- 法人证件号码(e路通)
    ,phone_eb  -- 法人手机号码(e路通)
    ,contact_address_eb  -- 地址(e路通)
    ,proxy_name_eb  -- 经办人姓名(e路通)
    ,proxy_papers_type_eb  -- 经办人证件种类(e路通)
    ,proxy_papers_number_eb  -- 经办人证件号码(e路通)
    ,proxy_phone_eb  -- 经办人手机号码(e路通)
    ,uuid  -- 图片id(e路通)
    ,isorganizpaper  -- 组织机构代码证是否为第一证件（0否，1是）
    ,papers_contact_address  -- 注册地址（营业执照）
    ,papers_principal_name  -- 法人姓名（营业执照）
    ,papers_papers_number  -- 证件号码（营业执照）
    ,papers_cust_name  -- 存款人（营业执照）
    ,papers_registerfund  -- 注册资金（营业执照）
    ,papers_operate_scope  -- 经营范围（营业执照）
    ,torpa_nat_register_no  -- rpa备案国税登记证号
    ,torpa_local_register_no  -- rpa备案地税登记证号
    ,is_need_eluton_inchange  -- ????????????e·?-1???-2?????
    ,torpa_scope  -- ??rpa?????????Χ
    ,torpa_found_date  -- ??rpa??????????
    ,torpa_call_phone  -- ??rpa????????绰
    ,papers_type_eb  -- 第一证件类型
    ,registerfund_eb  -- 注册资金（送变更人行）
    ,istoscope_pb  -- 是否变更经营范围（送变更人行）-1是-2否
    ,deposit_type_eb  -- 存款人类别（变更送e路通）
    ,acct_opendt_eb  -- 开户日期（变更送e路通）
    ,trade_type_eb  -- 行业分类（变更送e路通）
    ,found_date_eb  -- 成立日期（变更送e路通）
    ,perpers_invaldt_eb  -- 营业期限（变更送e路通）
    ,principal_invaldt_eb  -- 法人证件有效期日（变更送e路通）
    ,acct_name_eb  -- 账户名称（送变更e路通）
    ,rpa_people_count  -- 人行备案次数
    ,rpa_manual_record  -- 是否人工备案：1-是 其他-否
    ,rpa_max_count  -- 配置循环备案最大数次
    ,ecfi_papers_t  -- 原ecif第二证件值
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.id,chr(13),''),chr(10),'')  -- id
    ,replace(replace(t1.scan_seq_no,chr(13),''),chr(10),'')  -- 流水号
    ,t1.create_time  -- 创建时间
    ,t1.start_time  -- 人行备案开始时间
    ,t1.end_time  -- 人行备案结束时间 
    ,replace(replace(t1.people_fail_reason,chr(13),''),chr(10),'')  -- 人行备案失败原因
    ,replace(replace(t1.query_type,chr(13),''),chr(10),'')  -- 查询登记类型:1登记2变更
    ,replace(replace(t1.ilegal_relat_company,chr(13),''),chr(10),'')  -- 法人关联企业
    ,replace(replace(t1.ilegal_relat_acctno,chr(13),''),chr(10),'')  -- 法人关联账户
    ,replace(replace(t1.ilegal_phone_relat_acctno,chr(13),''),chr(10),'')  -- 法人同一手机号码关联账户
    ,replace(replace(t1.oprerator_relat_acctno,chr(13),''),chr(10),'')  -- 经办人关联账户
    ,replace(replace(t1.oprerator_phone_relat_acctno,chr(13),''),chr(10),'')  -- 经办人同一手机号码关联账户
    ,replace(replace(t1.similar_relat_acctno,chr(13),''),chr(10),'')  -- 相似关联账户
    ,replace(replace(t1.similar_addr_relat_company,chr(13),''),chr(10),'')  -- 相似住所关联企业
    ,replace(replace(t1.is_hanging_acctno,chr(13),''),chr(10),'')  -- 是否久悬账户
    ,replace(replace(t1.rec_type,chr(13),''),chr(10),'')  -- 备案类型： 0本地备案1异地备案
    ,replace(replace(t1.people_bank_rpa_result,chr(13),''),chr(10),'')  -- 人行备案结果：0未备案1备案失败2备案成功3备案中
    ,replace(replace(t1.guangdong_company_rpa_result,chr(13),''),chr(10),'')  -- 广东省企业备案结果：0未备案1备案失败2备案成功3备案中
    ,replace(replace(t1.guangdong_company_fail_reason,chr(13),''),chr(10),'')  -- 广东省企业备案失败原因
    ,replace(replace(t1.des_file_name,chr(13),''),chr(10),'')  -- 本地文件路径名
    ,replace(replace(t1.sdi_file_path,chr(13),''),chr(10),'')  -- 远程凭证路径
    ,t1.gd_start_time  -- 广东备案开始时间
    ,t1.gd_end_time  -- 广东备案结束时间
    ,replace(replace(t1.people_bank_query_rpa_result,chr(13),''),chr(10),'')  -- 人行信息查询结果 -0未返回、-1正常、-2异常
    ,replace(replace(t1.people_bank_query_rpa_fr,chr(13),''),chr(10),'')  -- 人行信息查询失败原因
    ,replace(replace(t1.guangdong_record_rpa_result,chr(13),''),chr(10),'')  -- 广东省信息查询结果 -0未返回、-1正常、-2异常
    ,replace(replace(t1.guangdong_record_rpa_fr,chr(13),''),chr(10),'')  -- 广东省信息查询失败原因
    ,replace(replace(t1.sz_image_result,chr(13),''),chr(10),'')  -- 深圳影像备案结果：0未备案1备案失败2备案成功3备案中
    ,replace(replace(t1.sz_image_fail_reason,chr(13),''),chr(10),'')  -- 深圳影像备案失败原因
    ,t1.sz_start_time  -- 深圳影像备案开始时间
    ,t1.sz_end_time  -- 深圳影像备案结束时间
    ,replace(replace(t1.is_flag,chr(13),''),chr(10),'')  -- 标记是否记录过备案信息 1为是0 为否
    ,replace(replace(t1.pw_file_name,chr(13),''),chr(10),'')  -- 存款人查询密码 影像名称
    ,replace(replace(t1.pw_file_path,chr(13),''),chr(10),'')  -- 存款人查询密码 影像路径
    ,replace(replace(t1.op_account_num,chr(13),''),chr(10),'')  -- 开户许可证编号
    ,replace(replace(t1.gd_notsz_flag,chr(13),''),chr(10),'')  -- 深圳开户企业标记 -1是 2否
    ,replace(replace(t1.old_open_licen,chr(13),''),chr(10),'')  -- 原开户许可证号
    ,replace(replace(t1.sz_is_have_id,chr(13),''),chr(10),'')  -- 是否有证 1有 2没有
    ,replace(replace(t1.arcid,chr(13),''),chr(10),'')  -- 案卷表id
    ,replace(replace(t1.pboc,chr(13),''),chr(10),'')  -- 人行查询（0为不查询，1为查询）
    ,replace(replace(t1.ebank,chr(13),''),chr(10),'')  --  e路通查询(0为不查询,1为查询)
    ,replace(replace(t1.iselsewhere,chr(13),''),chr(10),'')  -- 是否异地(人行；0否，1是)
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 存款人名称
    ,replace(replace(t1.deposit_type,chr(13),''),chr(10),'')  -- 存款人类别
    ,replace(replace(t1.telephone,chr(13),''),chr(10),'')  -- 电话
    ,replace(replace(t1.compay_fin_type,chr(13),''),chr(10),'')  -- 法人种类
    ,replace(replace(t1.principal_name,chr(13),''),chr(10),'')  -- 法人姓名
    ,replace(replace(t1.principal_papers_type,chr(13),''),chr(10),'')  -- 法人证件种类
    ,replace(replace(t1.principal_papers_number,chr(13),''),chr(10),'')  -- 法人证件号码
    ,replace(replace(t1.district_code,chr(13),''),chr(10),'')  -- 注册地区代码
    ,replace(replace(t1.register_curr_type,chr(13),''),chr(10),'')  -- 注册资金币种
    ,replace(replace(t1.registerfund,chr(13),''),chr(10),'')  -- 注册资金
    ,replace(replace(t1.compay_organiz_code,chr(13),''),chr(10),'')  -- 组织机构代码
    ,replace(replace(t1.papers_type,chr(13),''),chr(10),'')  -- 第一证明文件种类
    ,replace(replace(t1.papers_number,chr(13),''),chr(10),'')  -- 第一证明文件编号
    ,replace(replace(t1.papers_type2,chr(13),''),chr(10),'')  -- 第二证明文件种类
    ,replace(replace(t1.papers_number2,chr(13),''),chr(10),'')  -- 第二证明文件编号
    ,replace(replace(t1.nat_register_no,chr(13),''),chr(10),'')  -- 国税登记证号
    ,replace(replace(t1.local_register_no,chr(13),''),chr(10),'')  -- 地税税登记证号
    ,replace(replace(t1.contact_address,chr(13),''),chr(10),'')  -- 地址
    ,replace(replace(t1.operate_scope,chr(13),''),chr(10),'')  -- 经营范围
    ,replace(replace(t1.torpa_compay_oragniz_code,chr(13),''),chr(10),'')  -- rpa备案上级法人组织机构代码
    ,replace(replace(t1.organiz_code,chr(13),''),chr(10),'')  -- rpa备案组织机构代码
    ,replace(replace(t1.papers_kind,chr(13),''),chr(10),'')  -- 第一证明文件种类(预受理)
    ,replace(replace(t1.papers_id,chr(13),''),chr(10),'')  -- 第一证明文件编号（预受理）
    ,replace(replace(t1.approveno,chr(13),''),chr(10),'')  -- 核准号(人行)
    ,replace(replace(t1.distinctcode,chr(13),''),chr(10),'')  -- 地区代码(人行)
    ,replace(replace(t1.brcode,chr(13),''),chr(10),'')  -- 网点号(人行)
    ,replace(replace(t1.imagename,chr(13),''),chr(10),'')  -- 图片名
    ,replace(replace(t1.filepath,chr(13),''),chr(10),'')  -- 路径
    ,replace(replace(t1.cust_name_eb,chr(13),''),chr(10),'')  -- 存款人(e路通)
    ,replace(replace(t1.papers_number_eb,chr(13),''),chr(10),'')  -- 营业执照号码(e路通)
    ,replace(replace(t1.principal_name_eb,chr(13),''),chr(10),'')  -- 法人姓名(e路通)
    ,replace(replace(t1.principal_papers_type_eb,chr(13),''),chr(10),'')  -- 法人证件种类(e路通)
    ,replace(replace(t1.principal_papers_number_eb,chr(13),''),chr(10),'')  -- 法人证件号码(e路通)
    ,replace(replace(t1.phone_eb,chr(13),''),chr(10),'')  -- 法人手机号码(e路通)
    ,replace(replace(t1.contact_address_eb,chr(13),''),chr(10),'')  -- 地址(e路通)
    ,replace(replace(t1.proxy_name_eb,chr(13),''),chr(10),'')  -- 经办人姓名(e路通)
    ,replace(replace(t1.proxy_papers_type_eb,chr(13),''),chr(10),'')  -- 经办人证件种类(e路通)
    ,replace(replace(t1.proxy_papers_number_eb,chr(13),''),chr(10),'')  -- 经办人证件号码(e路通)
    ,replace(replace(t1.proxy_phone_eb,chr(13),''),chr(10),'')  -- 经办人手机号码(e路通)
    ,replace(replace(t1.uuid,chr(13),''),chr(10),'')  -- 图片id(e路通)
    ,replace(replace(t1.isorganizpaper,chr(13),''),chr(10),'')  -- 组织机构代码证是否为第一证件（0否，1是）
    ,replace(replace(t1.papers_contact_address,chr(13),''),chr(10),'')  -- 注册地址（营业执照）
    ,replace(replace(t1.papers_principal_name,chr(13),''),chr(10),'')  -- 法人姓名（营业执照）
    ,replace(replace(t1.papers_papers_number,chr(13),''),chr(10),'')  -- 证件号码（营业执照）
    ,replace(replace(t1.papers_cust_name,chr(13),''),chr(10),'')  -- 存款人（营业执照）
    ,replace(replace(t1.papers_registerfund,chr(13),''),chr(10),'')  -- 注册资金（营业执照）
    ,replace(replace(t1.papers_operate_scope,chr(13),''),chr(10),'')  -- 经营范围（营业执照）
    ,replace(replace(t1.torpa_nat_register_no,chr(13),''),chr(10),'')  -- rpa备案国税登记证号
    ,replace(replace(t1.torpa_local_register_no,chr(13),''),chr(10),'')  -- rpa备案地税登记证号
    ,replace(replace(t1.is_need_eluton_inchange,chr(13),''),chr(10),'')  -- ????????????e·?-1???-2?????
    ,replace(replace(t1.torpa_scope,chr(13),''),chr(10),'')  -- ??rpa?????????Χ
    ,replace(replace(t1.torpa_found_date,chr(13),''),chr(10),'')  -- ??rpa??????????
    ,replace(replace(t1.torpa_call_phone,chr(13),''),chr(10),'')  -- ??rpa????????绰
    ,replace(replace(t1.papers_type_eb,chr(13),''),chr(10),'')  -- 第一证件类型
    ,replace(replace(t1.registerfund_eb,chr(13),''),chr(10),'')  -- 注册资金（送变更人行）
    ,replace(replace(t1.istoscope_pb,chr(13),''),chr(10),'')  -- 是否变更经营范围（送变更人行）-1是-2否
    ,replace(replace(t1.deposit_type_eb,chr(13),''),chr(10),'')  -- 存款人类别（变更送e路通）
    ,replace(replace(t1.acct_opendt_eb,chr(13),''),chr(10),'')  -- 开户日期（变更送e路通）
    ,replace(replace(t1.trade_type_eb,chr(13),''),chr(10),'')  -- 行业分类（变更送e路通）
    ,replace(replace(t1.found_date_eb,chr(13),''),chr(10),'')  -- 成立日期（变更送e路通）
    ,replace(replace(t1.perpers_invaldt_eb,chr(13),''),chr(10),'')  -- 营业期限（变更送e路通）
    ,replace(replace(t1.principal_invaldt_eb,chr(13),''),chr(10),'')  -- 法人证件有效期日（变更送e路通）
    ,replace(replace(t1.acct_name_eb,chr(13),''),chr(10),'')  -- 账户名称（送变更e路通）
    ,replace(replace(t1.rpa_people_count,chr(13),''),chr(10),'')  -- 人行备案次数
    ,replace(replace(t1.rpa_manual_record,chr(13),''),chr(10),'')  -- 是否人工备案：1-是 其他-否
    ,replace(replace(t1.rpa_max_count,chr(13),''),chr(10),'')  -- 配置循环备案最大数次
    ,replace(replace(t1.ecfi_papers_t,chr(13),''),chr(10),'')  -- 原ecif第二证件值
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.pbss_acs_t_rpa_acct_record t1    --
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')  ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pbss_acs_t_rpa_acct_record',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);