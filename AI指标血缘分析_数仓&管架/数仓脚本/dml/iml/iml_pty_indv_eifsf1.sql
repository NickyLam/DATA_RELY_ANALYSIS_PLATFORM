/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_indv_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_indv add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_indv_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv partition for ('eifsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_indv_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_eifsf1_cl purge;
drop table ${iml_schema}.pty_indv_eifsf1_tmp purge;


-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_indv_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_indv_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_indv_eifsf1_tmp nologging
compress ${option_switch} for query high
as
(select t.*,
                    row_number() over(partition by party_id order by updated_ts desc) rn
               from ${iol_schema}.eifs_t01_per_cust_ext_info t
              where t.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and t.end_dt > to_date('${batch_date}', 'yyyymmdd'));

-- 3.1 get new data into table
-- eifs_t01_corp_rel_per_info-1
insert into ${iml_schema}.pty_indv_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,ctrler_type_cd -- 股东类型代码
    ,shard_type_cd -- 控制人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,' ' -- 人行客户编号
    ,' ' -- 个人英文名称
    ,${iml_schema}.dateformat_min(P1.BIRTH_DT) -- 出生日期
    ,' ' -- 出生地址
    ,'299' -- 存款人类别代码
    ,P1.RELA_NAME -- 当事人名称
    ,'-' -- 个体工商户标志
    ,' ' -- 个体工商户证件号码
    ,NVL(TRIM(P1.RELA_NATION_CD),'XXX') -- 国籍代码
    ,'90' -- 婚姻状况代码
    ,' ' -- 籍贯代码
    ,'9' -- 居住状况代码
    ,'00' -- 民族代码
    ,' ' -- 纳税人识别号
    ,' ' -- 实名标志
    ,'XXX' -- 税收居民国家代码组合
    ,NVL(TRIM(p1.TAX_PAY_CTZN_IDNT),'5') -- 税收居民身份类型代码
    ,'-' -- 小微企业主标志
    ,' ' -- 小微企业主证件号码
    ,'0000' -- 小微企业主证件类型代码
    ,NVL(TRIM(p1.GENDER_CD),'0') -- 性别代码
    ,' ' -- 姓名
    ,'9' -- 学位代码
    ,'0' -- 血型代码
    ,' ' -- 农村承包经营户标志
    ,'-' -- 农户标志
    ,'0' -- 有工作单位标志
    ,NVL(TRIM(p1.POS_LEVEL_CD),'9') -- 职务代码
    ,NVL(TRIM(p1.TITLE_CD),'99') -- 职称等级代码
    ,'0' -- 居民性质代码
    ,nvl(trim(p4.cert_issue_zone_cd),'000000') -- 地区代码
    ,'-' -- 行员标志
    ,'000000' -- 行政区划代码
    ,'-' -- 居民标志
    ,' ' -- 籍贯
    ,MONTHS_BETWEEN(to_date('${batch_date}','yyyymmdd'),${iml_schema}.dateformat_min(p1.BIRTH_DT))/12 -- 年龄
    ,'0' -- 业主类型代码
    ,NVL(TRIM(p6.Poltc_Stat_Cd),'-') -- 政治面貌代码
    ,'0' -- 本行关系人标志
    ,'-' -- 健康状况代码
    ,' ' -- 口语
    ,'0' -- 系统内客户标志
    ,NVL(TRIM(P5.CUST_CARD_LEVEL_CD),'0') -- 客户级别代码
    ,p1.LNKM_SELF_CERT_DECL_FLG -- 税收居民取得自证声明标志
    ,'-' -- 个人当事人类型代码
    ,'9' -- 在我行职务类型代码
    ,P5.GRADUATE_SCHOOL -- 毕业院校
    ,'-' -- 授信客户标志
    ,'0'  -- 境内外标志
    ,' ' -- 纳税人识别号空值原因描述
    ,' ' -- 个体工商户证件类型代码
    ,' ' -- 贷款卡号
    ,' ' -- 社保卡卡号
    ,' ' -- 公积金账号
    ,' ' -- 代理开户标志
    ,' ' -- 推荐人类型代码
    ,' ' -- 推荐人号码
    ,'99' -- 从业状况代码
    ,P1.INIT_SYSTEM_ID -- 开户渠道代码
    ,' ' -- 法定英文姓氏
    ,' ' -- 法定英文中间名
    ,' ' -- 法定英文名
    ,NVL(TRIM(p1.CAREER_CD),'-') -- 职业代码
    ,P1.OTHER_POS_LEVEL -- 其他职业名称
    ,P1.HOLD_STOCK_RATIO -- 持股比例
    ,case when length(NVL(TRIM(P1.Ctrler_Typ_Cd),'-') )>29 then '@'|| NVL(TRIM(P1.Ctrler_Typ_Cd),'-')  else  NVL(TRIM(P1.Ctrler_Typ_Cd),'-')  end -- 股东类型代码
    ,NVL(TRIM(P1.SHRH_TYP_CD),'-') -- 控制人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_per_info p1
  left join ${iol_schema}.eifs_t00_party_pub_info p2
    on p1.rela_num = p2.cust_num
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t00_per_cust_cert_ref p4
    on p2.party_id = p4.party_id
   and p4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p4.is_main_cert = '1'
   and p4.updated_ts = to_date('99991231', 'yyyymmdd') --cym:只取有效数据
  left join ${iml_schema}.pty_indv_eifsf1_tmp p5
    on p1.party_id = p5.party_id
   and p5.rn = 1
  left join ${iol_schema}.eifs_t01_per_cust_info p6
    on p2.party_id = p6.party_id
   and p6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p6.end_dt > to_date('${batch_date}', 'yyyymmdd')
where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;

-- eifs_t01_per_cust_info-1
insert into ${iml_schema}.pty_indv_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,ctrler_type_cd -- 股东类型代码
    ,shard_type_cd -- 控制人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P3.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P3.PID -- 人行客户编号
    ,NVL(TRIM(P2.EN_NAME),' ') -- 个人英文名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.BIRTH_DT) -- 出生日期
    ,P1.BIRTH_PLACE -- 出生地址
    ,nvl(trim(P1.DEPOSITOR_TYPE_CD),'299')  -- 存款人类别代码
    ,P1.CUST_NAME -- 当事人名称
    ,NVL(TRIM(P4.IS_INDIV_MERCHANT),'-') -- 个体工商户标志
    ,NVL(P4.INDIV_BUSI_LICENSE,' ') -- 个体工商户证件号码
    ,NVL(TRIM(P2.NATION_CD),'XXX') -- 国籍代码
    ,NVL(TRIM(P1.MARRIAGE_SITU_CD),'90') -- 婚姻状况代码
    , '000000' -- 籍贯代码
    ,NVL(TRIM(P4.RESDNT_SITU_CD),'9') -- 居住状况代码
    ,CASE WHEN p1.ETHNIC_CD='99' THEN '00' 
ELSE NVL(TRIM(P1.ETHNIC_CD),'00') END -- 民族代码
    ,NVL(TRIM(P8.TAX_NUMBER),' ') -- 纳税人识别号
    ,NVL(TRIM(P5.LABEL_VALUE),' ') -- 实名标志
    ,NVL(TRIM(P8.TAX_COUNTRY),'XXX') -- 税收居民国家代码组合
    ,NVL(TRIM(P2.TAX_PAY_CTZN_IDNT),'5') -- 税收居民身份类型代码
    ,NVL(TRIM(P4.IS_SMALL_MICRO_ENT),'-') -- 小微企业主标志
    ,NVL(P4.SMALL_MICRO_ENT_LICENSE,' ') -- 小微企业主证件号码
    ,P4.SMALL_MICRO_ENT_TYPE -- 小微企业主证件类型代码
    ,NVL(TRIM(P1.GENDER_CD),'0') -- 性别代码
    ,P1.CUST_NAME -- 姓名
    ,NVL(TRIM(P1.SUPR_DEGREE_CD),'9') -- 学位代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||NVL(P4.BLOOD_TYPE_CD,' ') END -- 血型代码
    ,' ' -- 农村承包经营户标志
    ,NVL(TRIM(P2.FARMER_FLAG),'-') -- 农户标志
    ,'0' -- 有工作单位标志
    ,NVL(TRIM(P1.POS_LEVEL_CD),'9') -- 职务代码
    ,NVL(TRIM(P1.TITLE_CD),'99') -- 职称等级代码
    ,NVL(TRIM(P4.RESDNT_CHAR_CD),'0') -- 居民性质代码
    ,nvl(trim(p6.cert_issue_zone_cd),'000000') -- 地区代码
    ,NVL(TRIM(P1.EMPLY_IND),'-') -- 行员标志
    ,P2.ADDR_DIST_CD -- 行政区划代码
    ,CASE WHEN P4.RESDNT_CHAR_CD='1' THEN '1' WHEN P4.RESDNT_CHAR_CD='2' THEN '0' ELSE '-' END -- 居民标志
    ,P1.BIRTH_PLACE_CD -- 籍贯
    ,MONTHS_BETWEEN(to_date('${batch_date}','yyyymmdd'),${iml_schema}.dateformat_min(p1.BIRTH_DT))/12 -- 年龄
    ,NVL(p2.Dom_Forgn_Cd,'0') -- 业主类型代码
    ,NVL(TRIM(P1.POLTC_STAT_CD),'-') -- 政治面貌代码
    ,'0' -- 本行关系人标志
    ,'-'-- 健康状况代码
    ,' ' -- 口语
    ,'0' -- 系统内客户标志
    ,NVL(TRIM(P4.CUST_CARD_LEVEL_CD),'0') -- 客户级别代码
    ,NVL(TRIM(P8.TAX_SELF_DECLARE),' ') -- 税收居民取得自证声明标志
    ,nvl(trim(P2.Cust_Type_Cd),'-') -- 个人当事人类型代码
    ,' ' -- 在我行职务类型代码
    ,P4.GRADUATE_SCHOOL -- 毕业院校
    ,'-' -- 授信客户标志
    ,NVL(trim(p2.Dom_Forgn_Cd),'0') -- 境内外标志
    ,NVL(TRIM(P8.TAX_NULL_REASON),' ') -- 纳税人识别号空值原因描述
    ,P4.INDIV_BUSI_TYPE -- 个体工商户证件类型代码
    ,NVL(P4.LOAN_CARD_NUM,' ') -- 贷款卡号
    ,NVL(P4.SOCL_CARD_NO,' ') -- 社保卡卡号
    ,NVL(P4.FUND_ACCT_NO,' ') -- 公积金账号
    ,case when P2.AGENT_ACCT_OPEN='2' then '1' when P2.AGENT_ACCT_OPEN='1' then '0' else '-' end -- 代理开户标志
    ,NVL(TRIM(P2.RECOMMENDATION_TYPE),'0') -- 推荐人类型代码
    ,NVL(P2.RECOMMENDATION_NUM,' ') -- 推荐人号码
    ,NVL(TRIM(P1.WORK_STAT_CD),'99') -- 从业状况代码
    ,P3.INIT_SYSTEM_ID -- 开户渠道代码
    ,P8.LEGAL_EN_FAMILY_NAME -- 法定英文姓氏
    ,P8.MIDDLE_NAME -- 法定英文中间名
    ,P8.LEGAL_EN_FIRST_NAME -- 法定英文名
    ,NVL(TRIM(P1.CAREER_CD),'-') -- 职业代码
    ,P1.OTHER_OCCUPATION -- 其他职业名称
    ,0.0 -- 持股比例
    ,'-' -- 股东类型代码
    ,'-' -- 控制人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_cust_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_cust_info p1
  left join ${iol_schema}.eifs_t00_party_pub_info p2
    on p1.party_id = p2.party_id
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t00_per_cust_no_ref p3
    on p1.party_id = p3.party_id
   and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_indv_eifsf1_tmp p4
    on p1.party_id = p4.party_id
   and p4.rn = 1
  left join ${iol_schema}.eifs_t01_per_tax_info p8
    on p1.party_id = p8.party_id
   and p8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p8.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p8.updated_ts = to_date('99991231', 'yyyymmdd') 
  left join ${iol_schema}.eifs_t08_per_cust_tag_info p5
    on p1.party_id = p5.party_id
   and p5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p5.label_type_cd = 'P0005'
  left join ${iml_schema}.ref_pub_cd_map r2
    on nvl(p4.blood_type_cd, ' ') = r2.src_code_val
   and r2.sorc_sys_cd = 'EIFS2'
   and r2.src_tab_en_name = 'EIFS_T01_PER_CUST_EXT_INFO'
   and r2.src_field_en_name = 'BLOOD_TYPE_CD'
   and r2.target_tab_en_name = 'PTY_INDV'
   and r2.target_tab_field_en_name = 'BLOOD_TYPE_CD'
  left join ${iol_schema}.eifs_t00_per_cust_cert_ref p6
    on p1.party_id = p6.party_id
   and p6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p6.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p6.is_main_cert = '1'
   and p6.updated_ts = to_date('99991231', 'yyyymmdd') --cym:只取有效数据
  left join ${iol_schema}.eifs_t08_per_cust_tag_info p12
    on p1.party_id = p12.party_id
   and p12.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p12.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p12.label_type_cd = 'P0005'
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;

-- eifs_t01_per_rel_per_info-1
insert into ${iml_schema}.pty_indv_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,ctrler_type_cd -- 股东类型代码
    ,shard_type_cd -- 控制人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,' ' -- 人行客户编号
    ,' ' -- 个人英文名称
    ,${iml_schema}.dateformat_min(P1.BIRTH_DT) -- 出生日期
    ,' ' -- 出生地址
    ,'299' -- 存款人类别代码
    ,P1.RELA_NAME -- 当事人名称
    ,'-' -- 个体工商户标志
    ,' ' -- 个体工商户证件号码
    ,'XXX' -- 国籍代码
    ,'90' -- 婚姻状况代码
    ,' ' -- 籍贯代码
    ,'9' -- 居住状况代码
    ,'00' -- 民族代码
    ,' ' -- 纳税人识别号
    ,' ' -- 实名标志
    ,'XXX' -- 税收居民国家代码组合
    ,NVL(TRIM(p1.TAX_PAY_CTZN_IDNT),'5') -- 税收居民身份类型代码
    ,'-' -- 小微企业主标志
    ,' ' -- 小微企业主证件号码
    ,'0000' -- 小微企业主证件类型代码
    ,NVL(TRIM(p1.Gender_Cd),'0') -- 性别代码
    ,' ' -- 姓名
    ,'9' -- 学位代码
    ,'0' -- 血型代码
    ,' ' -- 农村承包经营户标志
    ,'-' -- 农户标志
    ,'0' -- 有工作单位标志
    ,NVL(TRIM(p1.Pos_Level_Cd),'9') -- 职务代码
    ,NVL(TRIM(p1.Title_Cd),'99') -- 职称等级代码
    ,'0' -- 居民性质代码
    ,nvl(trim(p4.cert_issue_zone_cd),'000000') -- 地区代码
    ,'-' -- 行员标志
    ,'000000' -- 行政区划代码
    ,'-' -- 居民标志
    ,' ' -- 籍贯
    ,MONTHS_BETWEEN(to_date('${batch_date}','yyyymmdd'),${iml_schema}.dateformat_min(p1.BIRTH_DT))/12 -- 年龄
    ,'0' -- 业主类型代码
    ,NVL(TRIM(p5.Poltc_Stat_Cd),'-') -- 政治面貌代码
    ,'0' -- 本行关系人标志
    ,'-' -- 健康状况代码
    ,' ' -- 口语
    ,'0' -- 系统内客户标志
    ,NVL(TRIM(P6.CUST_CARD_LEVEL_CD),'0') -- 客户级别代码
    ,' ' -- 税收居民取得自证声明标志
    ,'-' -- 个人当事人类型代码
    ,'9' -- 在我行职务类型代码
    ,P6.GRADUATE_SCHOOL -- 毕业院校
    ,'-' -- 授信客户标志
    ,'0'  -- 境内外标志
    ,' ' -- 纳税人识别号空值原因描述
    ,'0000' -- 个体工商户证件类型代码
    ,' ' -- 贷款卡号
    ,' ' -- 社保卡卡号
    ,' ' -- 公积金账号
    ,' ' -- 代理开户标志
    ,' ' -- 推荐人类型代码
    ,' ' -- 推荐人号码
    ,'99' -- 从业状况代码
    ,P1.INIT_SYSTEM_ID -- 开户渠道代码
    ,' ' -- 法定英文姓氏
    ,' ' -- 法定英文中间名
    ,' ' -- 法定英文名
    ,NVL(TRIM(p1.PARTY_OCCUPATION),'-') -- 职业代码
    ,P1.OTHER_POS_LEVEL -- 其他职业名称
    ,0 -- 持股比例
    ,'-' -- 股东类型代码
    ,'-' -- 控制人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
 from ${iol_schema}.eifs_t01_per_rel_per_info p1
  left join ${iol_schema}.eifs_t00_party_pub_info p2
    on p1.rela_num = p2.cust_num
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iol_schema}.eifs_t00_per_cust_cert_ref p4
    on p1.party_id = p4.party_id
   and p4.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p4.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and p4.is_main_cert = '1'
   and p4.updated_ts = to_date('99991231', 'yyyymmdd') --cym:只取有效数据
  left join ${iol_schema}.eifs_t01_per_cust_info p5
    on p1.party_id = p5.party_id
   and p5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p5.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join ${iml_schema}.pty_indv_eifsf1_tmp p6
    on p1.party_id = p6.party_id
   and p6.rn = 1
 where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
   ;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_indv_eifsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.pbc_cust_num, o.pbc_cust_num) as pbc_cust_num -- 人行客户编号
    ,nvl(n.indv_en_name, o.indv_en_name) as indv_en_name -- 个人英文名称
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.birth_addr, o.birth_addr) as birth_addr -- 出生地址
    ,nvl(n.depositr_cate_cd, o.depositr_cate_cd) as depositr_cate_cd -- 存款人类别代码
    ,nvl(n.party_name, o.party_name) as party_name -- 当事人名称
    ,nvl(n.indv_bus_flg, o.indv_bus_flg) as indv_bus_flg -- 个体工商户标志
    ,nvl(n.indv_bus_cert_no, o.indv_bus_cert_no) as indv_bus_cert_no -- 个体工商户证件号码
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.marriage_situ_cd, o.marriage_situ_cd) as marriage_situ_cd -- 婚姻状况代码
    ,nvl(n.nati_place_cd, o.nati_place_cd) as nati_place_cd -- 籍贯代码
    ,nvl(n.resd_status_cd, o.resd_status_cd) as resd_status_cd -- 居住状况代码
    ,nvl(n.nationty_cd, o.nationty_cd) as nationty_cd -- 民族代码
    ,nvl(n.taxpayer_idtfy_num, o.taxpayer_idtfy_num) as taxpayer_idtfy_num -- 纳税人识别号
    ,nvl(n.real_name_flg, o.real_name_flg) as real_name_flg -- 实名标志
    ,nvl(n.tax_resdnt_cty_cd, o.tax_resdnt_cty_cd) as tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,nvl(n.tax_resdnt_idti_type_cd, o.tax_resdnt_idti_type_cd) as tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,nvl(n.sm_bus_owner_flg, o.sm_bus_owner_flg) as sm_bus_owner_flg -- 小微企业主标志
    ,nvl(n.sm_bus_owner_cert_no, o.sm_bus_owner_cert_no) as sm_bus_owner_cert_no -- 小微企业主证件号码
    ,nvl(n.sm_bus_owner_cert_type_cd, o.sm_bus_owner_cert_type_cd) as sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.degree_cd, o.degree_cd) as degree_cd -- 学位代码
    ,nvl(n.blood_type_cd, o.blood_type_cd) as blood_type_cd -- 血型代码
    ,nvl(n.ctysd_contr_oper_acct_flg, o.ctysd_contr_oper_acct_flg) as ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(n.have_work_unit_flg, o.have_work_unit_flg) as have_work_unit_flg -- 有工作单位标志
    ,nvl(n.post_cd, o.post_cd) as post_cd -- 职务代码
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称等级代码
    ,nvl(n.resdnt_char_cd, o.resdnt_char_cd) as resdnt_char_cd -- 居民性质代码
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 地区代码
    ,nvl(n.emply_flg, o.emply_flg) as emply_flg -- 行员标志
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区划代码
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.nati_place, o.nati_place) as nati_place -- 籍贯
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.owner_type_cd, o.owner_type_cd) as owner_type_cd -- 业主类型代码
    ,nvl(n.politic_status_cd, o.politic_status_cd) as politic_status_cd -- 政治面貌代码
    ,nvl(n.ghb_rela_peop_flg, o.ghb_rela_peop_flg) as ghb_rela_peop_flg -- 本行关系人标志
    ,nvl(n.health_status_cd, o.health_status_cd) as health_status_cd -- 健康状况代码
    ,nvl(n.spoken, o.spoken) as spoken -- 口语
    ,nvl(n.sys_in_cust_flg, o.sys_in_cust_flg) as sys_in_cust_flg -- 系统内客户标志
    ,nvl(n.cust_lev_cd, o.cust_lev_cd) as cust_lev_cd -- 客户级别代码
    ,nvl(n.tax_stament_flg, o.tax_stament_flg) as tax_stament_flg -- 税收居民取得自证声明标志
    ,nvl(n.indv_party_type_cd, o.indv_party_type_cd) as indv_party_type_cd -- 个人当事人类型代码
    ,nvl(n.hxb_post_type_cd, o.hxb_post_type_cd) as hxb_post_type_cd -- 在我行职务类型代码
    ,nvl(n.grad_school, o.grad_school) as grad_school -- 毕业院校
    ,nvl(n.crdt_cust_flg, o.crdt_cust_flg) as crdt_cust_flg -- 授信客户标志
    ,nvl(n.main_type_cd, o.main_type_cd) as main_type_cd -- 境内外标志
    ,nvl(n.tax_num_null_rs_descb, o.tax_num_null_rs_descb) as tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,nvl(n.indv_bus_cert_type_cd, o.indv_bus_cert_type_cd) as indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,nvl(n.loan_card_no, o.loan_card_no) as loan_card_no -- 贷款卡号
    ,nvl(n.soci_secu_card_no, o.soci_secu_card_no) as soci_secu_card_no -- 社保卡卡号
    ,nvl(n.provi_fund_acct_num, o.provi_fund_acct_num) as provi_fund_acct_num -- 公积金账号
    ,nvl(n.agent_open_flg, o.agent_open_flg) as agent_open_flg -- 代理开户标志
    ,nvl(n.referrer_type_cd, o.referrer_type_cd) as referrer_type_cd -- 推荐人类型代码
    ,nvl(n.referrer_num, o.referrer_num) as referrer_num -- 推荐人号码
    ,nvl(n.obtain_emply_situ_cd, o.obtain_emply_situ_cd) as obtain_emply_situ_cd -- 从业状况代码
    ,nvl(n.open_acct_chn_cd, o.open_acct_chn_cd) as open_acct_chn_cd -- 开户渠道代码
    ,nvl(n.legal_en_last_name, o.legal_en_last_name) as legal_en_last_name -- 法定英文姓氏
    ,nvl(n.legal_en_mdl_name, o.legal_en_mdl_name) as legal_en_mdl_name -- 法定英文中间名
    ,nvl(n.legal_en_name, o.legal_en_name) as legal_en_name -- 法定英文名
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业代码
    ,nvl(n.other_career_name, o.other_career_name) as other_career_name -- 其他职业名称
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 持股比例
    ,nvl(n.shard_type_cd, o.shard_type_cd) as shard_type_cd -- 股东类型代码
    ,nvl(n.ctrler_type_cd, o.ctrler_type_cd) as ctrler_type_cd -- 控制人类型代码
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_indv_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.pbc_cust_num <> n.pbc_cust_num
        or o.indv_en_name <> n.indv_en_name
        or o.birth_dt <> n.birth_dt
        or o.birth_addr <> n.birth_addr
        or o.depositr_cate_cd <> n.depositr_cate_cd
        or o.party_name <> n.party_name
        or o.indv_bus_flg <> n.indv_bus_flg
        or o.indv_bus_cert_no <> n.indv_bus_cert_no
        or o.nation_cd <> n.nation_cd
        or o.marriage_situ_cd <> n.marriage_situ_cd
        or o.nati_place_cd <> n.nati_place_cd
        or o.resd_status_cd <> n.resd_status_cd
        or o.nationty_cd <> n.nationty_cd
        or o.taxpayer_idtfy_num <> n.taxpayer_idtfy_num
        or o.real_name_flg <> n.real_name_flg
        or o.tax_resdnt_cty_cd <> n.tax_resdnt_cty_cd
        or o.tax_resdnt_idti_type_cd <> n.tax_resdnt_idti_type_cd
        or o.sm_bus_owner_flg <> n.sm_bus_owner_flg
        or o.sm_bus_owner_cert_no <> n.sm_bus_owner_cert_no
        or o.sm_bus_owner_cert_type_cd <> n.sm_bus_owner_cert_type_cd
        or o.gender_cd <> n.gender_cd
        or o.name <> n.name
        or o.degree_cd <> n.degree_cd
        or o.blood_type_cd <> n.blood_type_cd
        or o.ctysd_contr_oper_acct_flg <> n.ctysd_contr_oper_acct_flg
        or o.farm_flg <> n.farm_flg
        or o.have_work_unit_flg <> n.have_work_unit_flg
        or o.post_cd <> n.post_cd
        or o.title_cd <> n.title_cd
        or o.resdnt_char_cd <> n.resdnt_char_cd
        or o.rg_cd <> n.rg_cd
        or o.emply_flg <> n.emply_flg
        or o.dist_cd <> n.dist_cd
        or o.resdnt_flg <> n.resdnt_flg
        or o.nati_place <> n.nati_place
        or o.age <> n.age
        or o.owner_type_cd <> n.owner_type_cd
        or o.politic_status_cd <> n.politic_status_cd
        or o.ghb_rela_peop_flg <> n.ghb_rela_peop_flg
        or o.health_status_cd <> n.health_status_cd
        or o.spoken <> n.spoken
        or o.sys_in_cust_flg <> n.sys_in_cust_flg
        or o.cust_lev_cd <> n.cust_lev_cd
        or o.tax_stament_flg <> n.tax_stament_flg
        or o.indv_party_type_cd <> n.indv_party_type_cd
        or o.hxb_post_type_cd <> n.hxb_post_type_cd
        or o.grad_school <> n.grad_school
        or o.crdt_cust_flg <> n.crdt_cust_flg
        or o.main_type_cd <> n.main_type_cd
        or o.tax_num_null_rs_descb <> n.tax_num_null_rs_descb
        or o.indv_bus_cert_type_cd <> n.indv_bus_cert_type_cd
        or o.loan_card_no <> n.loan_card_no
        or o.soci_secu_card_no <> n.soci_secu_card_no
        or o.provi_fund_acct_num <> n.provi_fund_acct_num
        or o.agent_open_flg <> n.agent_open_flg
        or o.referrer_type_cd <> n.referrer_type_cd
        or o.referrer_num <> n.referrer_num
        or o.obtain_emply_situ_cd <> n.obtain_emply_situ_cd
        or o.open_acct_chn_cd <> n.open_acct_chn_cd
        or o.legal_en_last_name <> n.legal_en_last_name
        or o.legal_en_mdl_name <> n.legal_en_mdl_name
        or o.legal_en_name <> n.legal_en_name
        or o.career_cd <> n.career_cd
        or o.other_career_name <> n.other_career_name
        or o.share_ratio <> n.share_ratio
        or o.shard_type_cd <> n.shard_type_cd
        or o.ctrler_type_cd <> n.ctrler_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,pbc_cust_num -- 人行客户编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状况代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称等级代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 行员标志
    ,dist_cd -- 行政区划代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 境内外标志
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,loan_card_no -- 贷款卡号
    ,soci_secu_card_no -- 社保卡卡号
    ,provi_fund_acct_num -- 公积金账号
    ,agent_open_flg -- 代理开户标志
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,obtain_emply_situ_cd -- 从业状况代码
    ,open_acct_chn_cd -- 开户渠道代码
    ,legal_en_last_name -- 法定英文姓氏
    ,legal_en_mdl_name -- 法定英文中间名
    ,legal_en_name -- 法定英文名
    ,career_cd -- 职业代码
    ,other_career_name -- 其他职业名称
    ,share_ratio -- 持股比例
    ,shard_type_cd -- 股东类型代码
    ,ctrler_type_cd -- 控制人类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.pbc_cust_num -- 人行客户编号
    ,o.indv_en_name -- 个人英文名称
    ,o.birth_dt -- 出生日期
    ,o.birth_addr -- 出生地址
    ,o.depositr_cate_cd -- 存款人类别代码
    ,o.party_name -- 当事人名称
    ,o.indv_bus_flg -- 个体工商户标志
    ,o.indv_bus_cert_no -- 个体工商户证件号码
    ,o.nation_cd -- 国籍代码
    ,o.marriage_situ_cd -- 婚姻状况代码
    ,o.nati_place_cd -- 籍贯代码
    ,o.resd_status_cd -- 居住状况代码
    ,o.nationty_cd -- 民族代码
    ,o.taxpayer_idtfy_num -- 纳税人识别号
    ,o.real_name_flg -- 实名标志
    ,o.tax_resdnt_cty_cd -- 税收居民国家代码组合
    ,o.tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,o.sm_bus_owner_flg -- 小微企业主标志
    ,o.sm_bus_owner_cert_no -- 小微企业主证件号码
    ,o.sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,o.gender_cd -- 性别代码
    ,o.name -- 姓名
    ,o.degree_cd -- 学位代码
    ,o.blood_type_cd -- 血型代码
    ,o.ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,o.farm_flg -- 农户标志
    ,o.have_work_unit_flg -- 有工作单位标志
    ,o.post_cd -- 职务代码
    ,o.title_cd -- 职称等级代码
    ,o.resdnt_char_cd -- 居民性质代码
    ,o.rg_cd -- 地区代码
    ,o.emply_flg -- 行员标志
    ,o.dist_cd -- 行政区划代码
    ,o.resdnt_flg -- 居民标志
    ,o.nati_place -- 籍贯
    ,o.age -- 年龄
    ,o.owner_type_cd -- 业主类型代码
    ,o.politic_status_cd -- 政治面貌代码
    ,o.ghb_rela_peop_flg -- 本行关系人标志
    ,o.health_status_cd -- 健康状况代码
    ,o.spoken -- 口语
    ,o.sys_in_cust_flg -- 系统内客户标志
    ,o.cust_lev_cd -- 客户级别代码
    ,o.tax_stament_flg -- 税收居民取得自证声明标志
    ,o.indv_party_type_cd -- 个人当事人类型代码
    ,o.hxb_post_type_cd -- 在我行职务类型代码
    ,o.grad_school -- 毕业院校
    ,o.crdt_cust_flg -- 授信客户标志
    ,o.main_type_cd -- 境内外标志
    ,o.tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,o.indv_bus_cert_type_cd -- 个体工商户证件类型代码
    ,o.loan_card_no -- 贷款卡号
    ,o.soci_secu_card_no -- 社保卡卡号
    ,o.provi_fund_acct_num -- 公积金账号
    ,o.agent_open_flg -- 代理开户标志
    ,o.referrer_type_cd -- 推荐人类型代码
    ,o.referrer_num -- 推荐人号码
    ,o.obtain_emply_situ_cd -- 从业状况代码
    ,o.open_acct_chn_cd -- 开户渠道代码
    ,o.legal_en_last_name -- 法定英文姓氏
    ,o.legal_en_mdl_name -- 法定英文中间名
    ,o.legal_en_name -- 法定英文名
    ,o.career_cd -- 职业代码
    ,o.other_career_name -- 其他职业名称
    ,o.share_ratio -- 持股比例
    ,o.shard_type_cd -- 股东类型代码
    ,o.ctrler_type_cd -- 控制人类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_eifsf1_bk o
    left join ${iml_schema}.pty_indv_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_indv_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_indv;
--alter table ${iml_schema}.pty_indv truncate partition for ('eifsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_indv') 
               and substr(subpartition_name,1,8)=upper('p_eifsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_indv drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_indv modify partition p_eifsf1 
add subpartition p_eifsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

whenever sqlerror exit sql.sqlcode;
-- 4.3 exchange partition
alter table ${iml_schema}.pty_indv exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_indv_eifsf1_cl;
alter table ${iml_schema}.pty_indv exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_indv_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_indv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_indv_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_indv_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_indv', partname => 'p_eifsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
