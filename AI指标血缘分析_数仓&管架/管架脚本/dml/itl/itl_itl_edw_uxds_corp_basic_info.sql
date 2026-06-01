/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_uxds_corp_basic_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_uxds_corp_basic_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_uxds_corp_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_uxds_corp_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_uxds_corp_basic_info partition for (to_date('${batch_date}','yyyymmdd')) (
    seq -- 记录唯一标识
    ,ctime -- 记录创建时间
    ,mtime -- 记录修改时间
    ,rtime -- 记录通讯到用户端时间
    ,corp_nature -- 企业性质
    ,org_cn_introduction -- 机构简介(中文)
    ,domestic_listing_identifier -- 境内上市标识.是否发行ab股，用于区分境内上市公司和非上市公司 0：否 1：是
    ,currency_encode -- 货币编码
    ,accounting_firm_id -- 会计师事务所id
    ,law_firm_id -- 律师事务所id
    ,org_id -- 机构id
    ,org_name_cn -- 机构名称(中文)
    ,org_website -- 机构网址
    ,org_short_name_cn -- 机构简称(中文)
    ,staff_num -- 员工人数
    ,legal_representative -- 法人代表
    ,reg_address_cn -- 注册地址(中文)
    ,accounting_firm_name -- 会计师事务所名称
    ,law_firm_name -- 律师事务所名称
    ,charged_accountant -- 经办会计师
    ,charged_lawyer -- 经办律师
    ,district_encode -- 地区编码
    ,cn_regional_identifier -- 中国地区标识
    ,org_code -- 组织机构代码
    ,unified_social_credit_code -- 统一社会信用代码
    ,office_address_cn -- 办公地址(中文)
    ,postcode -- 邮政编码
    ,reg_asset -- 注册资金，单位：万元
    ,currency_name -- 货币名称
    ,established_date -- 成立日期
    ,email -- 电子信箱
    ,telephone -- 联系电话
    ,fax -- 联系传真
    ,main_operation_business -- 主营业务
    ,operating_scope -- 经营范围
    ,org_name_en -- 机构名称(英文)
    ,general_manager -- 总经理
    ,org_short_name_en -- 机构简称(英文)
    ,corp_ed -- 公司终止日期
    ,announcement_date -- 公告日期
    ,business_reg_num -- 工商登记号
    ,tax_reg_num -- 税务登记号
    ,secretary -- 董事会秘书
    ,sec_representative -- 证券事务代表
    ,org_type -- 机构类别
    ,reg_address_en -- 注册地址(英文)
    ,office_address_en -- 办公地址(英文)
    ,board_manage_analysis -- 董事会经营分析
    ,establishment_history -- 成立情况与历史沿革
    ,isvalid -- 是否有效
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(seq), 0) as seq -- 记录唯一标识
    ,nvl(ctime, to_date('00010101', 'yyyymmdd')) as ctime -- 记录创建时间
    ,nvl(mtime, to_date('00010101', 'yyyymmdd')) as mtime -- 记录修改时间
    ,nvl(rtime, to_date('00010101', 'yyyymmdd')) as rtime -- 记录通讯到用户端时间
    ,nvl(trim(corp_nature), ' ') as corp_nature -- 企业性质
    ,nvl(trim(org_cn_introduction), ' ') as org_cn_introduction -- 机构简介(中文)
    ,nvl(trim(domestic_listing_identifier), ' ') as domestic_listing_identifier -- 境内上市标识.是否发行ab股，用于区分境内上市公司和非上市公司 0：否 1：是
    ,nvl(trim(currency_encode), ' ') as currency_encode -- 货币编码
    ,nvl(trim(accounting_firm_id), ' ') as accounting_firm_id -- 会计师事务所id
    ,nvl(trim(law_firm_id), ' ') as law_firm_id -- 律师事务所id
    ,nvl(trim(org_id), ' ') as org_id -- 机构id
    ,nvl(trim(org_name_cn), ' ') as org_name_cn -- 机构名称(中文)
    ,nvl(trim(org_website), ' ') as org_website -- 机构网址
    ,nvl(trim(org_short_name_cn), ' ') as org_short_name_cn -- 机构简称(中文)
    ,nvl(trim(staff_num), 0) as staff_num -- 员工人数
    ,nvl(trim(legal_representative), ' ') as legal_representative -- 法人代表
    ,nvl(trim(reg_address_cn), ' ') as reg_address_cn -- 注册地址(中文)
    ,nvl(trim(accounting_firm_name), ' ') as accounting_firm_name -- 会计师事务所名称
    ,nvl(trim(law_firm_name), ' ') as law_firm_name -- 律师事务所名称
    ,nvl(trim(charged_accountant), ' ') as charged_accountant -- 经办会计师
    ,nvl(trim(charged_lawyer), ' ') as charged_lawyer -- 经办律师
    ,nvl(trim(district_encode), ' ') as district_encode -- 地区编码
    ,nvl(trim(cn_regional_identifier), 0) as cn_regional_identifier -- 中国地区标识
    ,nvl(trim(org_code), ' ') as org_code -- 组织机构代码
    ,nvl(trim(unified_social_credit_code), ' ') as unified_social_credit_code -- 统一社会信用代码
    ,nvl(trim(office_address_cn), ' ') as office_address_cn -- 办公地址(中文)
    ,nvl(trim(postcode), ' ') as postcode -- 邮政编码
    ,nvl(trim(reg_asset), 0) as reg_asset -- 注册资金，单位：万元
    ,nvl(trim(currency_name), ' ') as currency_name -- 货币名称
    ,nvl(established_date, to_date('00010101', 'yyyymmdd')) as established_date -- 成立日期
    ,nvl(trim(email), ' ') as email -- 电子信箱
    ,nvl(trim(telephone), ' ') as telephone -- 联系电话
    ,nvl(trim(fax), ' ') as fax -- 联系传真
    ,nvl(trim(main_operation_business), ' ') as main_operation_business -- 主营业务
    ,nvl(trim(operating_scope), ' ') as operating_scope -- 经营范围
    ,nvl(trim(org_name_en), ' ') as org_name_en -- 机构名称(英文)
    ,nvl(trim(general_manager), ' ') as general_manager -- 总经理
    ,nvl(trim(org_short_name_en), ' ') as org_short_name_en -- 机构简称(英文)
    ,nvl(corp_ed, to_date('00010101', 'yyyymmdd')) as corp_ed -- 公司终止日期
    ,nvl(announcement_date, to_date('00010101', 'yyyymmdd')) as announcement_date -- 公告日期
    ,nvl(trim(business_reg_num), ' ') as business_reg_num -- 工商登记号
    ,nvl(trim(tax_reg_num), ' ') as tax_reg_num -- 税务登记号
    ,nvl(trim(secretary), ' ') as secretary -- 董事会秘书
    ,nvl(trim(sec_representative), ' ') as sec_representative -- 证券事务代表
    ,nvl(trim(org_type), ' ') as org_type -- 机构类别
    ,nvl(trim(reg_address_en), ' ') as reg_address_en -- 注册地址(英文)
    ,nvl(trim(office_address_en), ' ') as office_address_en -- 办公地址(英文)
    ,nvl(trim(board_manage_analysis), ' ') as board_manage_analysis -- 董事会经营分析
    ,nvl(trim(establishment_history), ' ') as establishment_history -- 成立情况与历史沿革
    ,nvl(trim(isvalid), 0) as isvalid -- 是否有效
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_uxds_corp_basic_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_uxds_corp_basic_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_uxds_corp_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);