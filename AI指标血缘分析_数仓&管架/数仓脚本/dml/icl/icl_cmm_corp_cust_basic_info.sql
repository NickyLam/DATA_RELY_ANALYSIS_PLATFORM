/*
Purpose:    共性加工层-对公客户基本信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_corp_cust_basic_info
CreateDate: 20201111
Logs:
            增加一组公司集体信息
            2021/03/12 谢宁修改信贷币种代码逻辑
            2021/03/13 调整第一组EIFS【营业执照】取值逻辑，T13.cert_num --> nvl(T13.cert_num,t66.cert_num)
            2020/12/19 陈伟峰 增加字段【贷款卡号】
			      2021/01/19 谢  宁 增加字段【首贷日期】、【居民标志】默认值改动 0->1
            20210318 陈伟峰 增加开户机构编号
            20210324 陈伟峰 修改行业五级分类代码、行业信用评级代码、企业类型代码取数逻辑，eifs2.0补充迁移
            20210325 谢  宁 修改【三农标志】【企业年营业额】【上市公司标志】已无差异，【有无进出口经营权标志，逃废债企业标志，有无进出口经营项标志】还有差异
            20210325 谢  宁 修改【资产总额】 t8.asset_tot --> t15.asset_tot
            20210325 谢  宁 修改【经济组织形式代码】nvl(trim(t2.econ_orgnz_form_cd),replace(t1.econ_orgnz_form_cd,'00000','Z9999'))
            20210325 谢  宁 修改【开办资金，国家重点企业标志，办理税务登记证标志】
            20210405 李观莲 修改  所有制类型代码 集团客户组改为null ;行业类型代码_征信 集团客户组改为 '-'  ,政府融资平台标志 信贷组修改逻辑
            20210405 李观莲 修改  净资产总额，行业信用评级代码，税收机构类别代码，行业五级分类代码，开户渠道代码,注册日期 , 办理税务登记证标志
            20210407 李观莲 修改  客户种类代码的逻辑，贷款卡号优先级
            20210412 陈伟峰 增加字段【生产经营地址、生产经营地址邮政编码】
            20210412 陈伟峰 调整贷款卡号优先级，优先取信贷
            20210601 谢  宁 调整【企业成立日期，有无进出口经营权标志，贷款卡号、企业年收入、实收资本、实收资本币种、经营场地面积，资产总额，净资产总额】取数逻辑
            20210630 何桐金 增加字段【组织机构存续状态,企业身份标识类型,主要出资人个数,实际控制人个数,财务部门联系电话】
            20210719 谢  宁 调整【民营企业标志】decode(t1.privateent, '1', '1', '0') --> decode(t1.privateent, '1', '1', '2','0',' ')
            20210729 何桐金 调整【国民经济部门类型代码】，将null转为'000'
            20210830 何桐金  增加字段【境内外标志DOM_OVERS_FLG】
	          20210831 陈伟峰 调整【实收资本币种】字段逻辑，将代码'40'转成'-'其他
	          20210906 何桐金  1.调整【农村企业标志CTYSD_CORP_FLG】字段取值逻辑，改从EIFS系统的标签表中取
                             2.新增字段【基本账户开户行名称BASIC_ACCT_OPEN_BANK_NAME、基本账户账号BASIC_ACCT_ACCT_NUM】
            20210930 陈伟峰 调整【国民经济部门类型代码】的取值逻辑，当信贷为'000'时取EIFS的值
            20211107 何桐金 【iml_pty_group_party、iml_pty_cust、iml_pty_corp_cust】增加job_cd过滤条件
            20211215 陈伟峰 新增字段【绿色信贷分类代码，科技型企业分类代码，科技型企业认定日期】
            20211221 陈伟峰 调整客户经理取数逻辑，优先取信贷->优先取EIFS
            20220128 陈伟峰 新增字段【经营所在地行政区划代码】
            20220303 孙得鑫 新增字段【战略客户标志】,调整【注册地址RGST_ADDR】加工逻辑为取EIFS的注册地址
            20220328 谢  宁 新增字段【创建渠道代码、战略性新兴产业分类代码】
            20220422 陈伟峰 新增字段【法人机构名称、法人机构类型代码、法人机构客户编号】
            20220608 翟若平	1、调整第一组字段【开户渠道代码、行业类型代码、组织机构类型代码、集团客户标志、劳动密集型标志、集团客户标志二、集团母公司编号、逃废债企业标志、有无进出口经营项标志、所有制类型代码、企业关停标志、组织机构存续状态代码】的加工口径；
                            2、置空字段【文教健康标志-EDU_HEA_FLG、普惠标志-INC_FLG、三农标志-ARAF_FLG】
                            3、调整第三组的取数数据源，由原对公信贷系统调整为综合信贷系统
                            4、新增字段【股票代码】
			      20220615 温旺清 调整第三组字段【授信客户标志】的加工口径
			      20220627 朱觉军	1、调整第一组过滤条件，新一代客户类型落标
                                  2、调整第二组字段【客户类型代码】的加工口径
                                  3、调整第三组字段【客户英文名称】【开户日期】【开户柜员编号】的加工口径
			      20220705 温旺清 1、增加第四组【对公信贷集团客户和客户群】
                            2、调整第三组【对公信贷客户】中T5、T6临时表的过滤条件【P2.RELATIONSHIP IN ('1010', '1020') -》 P2.MEMBERTYPE IN ('10111', '10112')】
                               以及T6表的过滤条件【AND T6.MEM_TYPE_CD = '1010' -》 AND T6.MEM_TYPE_CD = '10111'】
		        20220708 温旺清 1、修改第一组临时表t9的取数来源 pty_party_elec_addr_h->pty_tel_info_h
			                      2、修改pty_party_phys_addr_h表的物理地址代码映射
		        20220720 温旺清 1、调整经济类型代码默认值econ_type_cd：000->900
		        20220801 曹永茂 组织机构类型代码空值处理：t4.orgnz_type_cd -> nvl(trim(t4.orgnz_type_cd),'00')
            20220802 黄俊杰 开户渠道代码 1001->100001
            20220805 李森辉 调整开户日期加工逻辑，当信贷开户日期为to_date('00010101', 'yyyymmdd')时或为空时，取ECIF开户日期
            20220810 曹永茂 1、调整第四组【银监小企业标志】默认值为‘0’
                            2、调整第一组【客户种类代码】的映射逻辑
            20220813 曹永茂 1、调整第三组关联t2表pty_corp_cust_group_info_h的逻辑，排序后取第一条数据
			      20220823 黄俊杰 1、调整 coalesce(trim(replace(t2.rg_cd,'000000','')),replace(trim(t1.rg_cd),'000000','999999')) -- 行政区划代码  -》 coalesce(trim(replace(t2.rg_cd,'000000','')),replace(trim(t1.rg_cd),'000000',''))  -- 行政区划代码
			      20220829 温旺清 1、调整第一组ECIF客户信息字段【行政区划代码rg_cd】加工逻辑，从优先取信贷改为仅取ECIF
			      20220905 曹永茂 1、信贷组【币种代码】不需要空值处理，否则永远取不到ECIF的值，调整为：nvl(trim(t1.registercurrency),'-')  - > t1.registercurrency
			                      2、调整第四组【币种代码】默认值为‘CNY’，保持与生产数据一致
			                      3、调整第四组【企业类型代码】的取数逻辑，t1.customertype -> t1.groupcredittype
				    20220908 温旺清 调整【创建渠道代码】的默认值加工逻辑
				    20220913 温旺清	调正临时表-对公业务流水表的取数逻辑：pbss_flw_t_corp_reg->SCPS_BP_CORPORATE_TB
				    20220916 曹永茂 1、调整【注册资金】的整合逻辑：当信贷为0或空时，都取ECIF的值
				                    2、调整【营业执照到期日期】的整合逻辑：当信贷值为空、最小日期或最大日期是，都取ECIF的值
				                    3、调整【注册日期】的整合逻辑：当信贷值为空、最小日期或最大日期是，都取ECIF的值
				    20220921 温旺清 调整第一组表pty_party_rela_h 加工逻辑。party_rela_type_cd '03'->'dw003'
				    20220922 曹永茂 调整【集团客户标志、客户状态代码】的空值默认值
				    20220922 温旺清 调整第三组对公信贷的【企业年营业额】取数口径
				    20220926 温旺清 调整临时表tmp_cmm_corp_cust_basic_info_01的 membertype的类型代码条件
            20220929 温旺清 调整第三组对公信贷的【经济性质代码】取数口径，新信贷组织类型转码迁入(老信贷OrgType手输不迁移，新信贷不使用)
            20220930 曹永茂 因电话类型代码落标，ECIF没有【联系电话_征信】类型，该字段置空
            20221011 温旺清 新增字段【反洗钱归属机构编号、自营客户标志代码、信贷客户标志代码、担保客户标志代码】
            20221019 温旺清 调整表pty_corp_cust_group_info_h过滤条件mem_status_cd='1'->mem_status_cd='0'，取消parent_corp_flg='1'的过滤条件
            20221020 翟若平 调整字段【经营所在地行政区划代码】的加工口径
			      20221102 温旺清 调整第三组【集团母公司编号】加工逻辑。
			      20221103 曹永茂 第二组【客户经理编号】取数口径，由取了客户经理名称改为取客户经理编号。
            20221104 温旺清 调整临时表tmp_cmm_corp_cust_basic_info_01中关联表icms_group_member_relative的过滤条件
            20221109 温旺清 调整【行业类型代码】加工口径
            20221122 温旺清 调整第一组【集团客户标志】【集团客户标志二】
	                        修改字段名称【自营客户类型代码SEL_SUP_CUST_FLG_CD】->【存款类客户标志DEP_CLASS_CUST_FLG】、【信贷客户类型代码CRDT_CUST_FLG_CD】->【贷款类客户标志LOAN_CLASS_CUST_FLG】、【担保客户类型代码GUAR_CUST_FLG_CD】->【担保类客户标志GUAR_CLASS_CUST_FLG】，调整字段【存款类客户标志、担保类客户标志、贷款类客户标志】加工逻辑
            20221212 翟若平 调整字段【企业成立日期】的加工口径
            20221219 曹永茂 调整经济类型代码默认值econ_type_cd：900->9999
            20230104 翟若平 调整第一组ECIF对公客户新的字段【控股类型代码】的加工口径
            20220106 曹永茂 根据新信贷提供的新口径，调整了信贷组的【组织机构代码、统一社会信用代码、营业执照号】的取数来源.
            20230113 翟若平 调整字段【集团客户标志、集团客户标志二】的加工口径
            20230223 温旺清 调整第一组的取数逻辑【企业年收入、企业年营业额】，根据映射，新信贷没有年收入字段信息。
			      20230309 温旺清 置空字段【收支方式代码、有董事会标志】,分别给默认值'-'、'0'
			      20230314 陈伟峰 调整字段【高新技术企业标志,关联方标志,企业成立日期,独立法人标志,离岸客户标志,属于两高行业标志,逃废债企业标志,有无进出口经营权标志,有无进出口经营项标志,办公地址邮政编码,民营企业标志,授信客户标志,人行支付行号,客户名称,客户英文名称,统一社会信用代码,营业执照到期日期】整合规则，仅取ECIF
            20230315 温旺清 调整【联系电话_征信】取数口径，因电话类型代码落标，ECIF把原本'20'的【联系电话_征信】类型迁移到'99'
			      20230320 陈伟峰 调整字段【集团类型代码、绿色债券项目标志】取数逻辑
            20230404 陈伟峰 调整【有董事会标志、关联集团类型代码、上市公司类型代码】取数逻辑，仅取信贷
                            调整【国家和行政区划代码,通讯地址，通讯地址邮政编码，高新技术企业标志,关联方标志,企业成立日期,独立法人标志,离岸客户标志,属于两高行业标志,逃废债企业标志,有无进出口经营权标志,有无进出口经营项标志,办公地址邮政编码,民营企业标志,授信客户标志,人行支付行号,农村企业标志,行政区划代码,注册日期,企业注册资本币种,办公地址,经济类型代码,行业类型代码,投资方国家代码,控股类型代码,实收资本,客户名称,客户英文名称,统一社会信用代码,营业执照到期日期,上市公司标志,绿色信贷客户标志,银监小企业标志,经营场地所有权代码,贷款卡号,地税登记证号码,国税登记证号码,金融许可证号,经营场地面积,经营范围,企业规模代码,企业员工人数,资产总额,存款人类别代码,净资产总额,集团客户编号,集团母公司编号,客户经理编号】取数逻辑，仅取ECIF
                            调整【开户日期】加工逻辑，置空信贷部分开户日期，仅取ECIF开户日期（为空时也不取信贷）
                            调整【企业类型代码】加工逻辑，	置空信贷部分企业类型代码，仅取ECIF
            20230410 陈伟峰 调整字段【授信客户标志】，还原回原来逻辑
            20230512 陈伟峰 调整集团客户部分的【所属行业类型】，优先取信贷再取ECIF
            20230517 陈伟峰 调整表eifs_t01_corp_cust_ext_info关联逻辑，增加UPDATED_TS字段
            20230605 陈伟峰 注：以下调整均分析过对应取值逻辑，理论上调整前后对数据无影响，仅是简化整合取值优先级。
                            1.置空【文教健康标志、普惠标志、三农标志、信贷客户风险评级代码、信贷客户风险评级开始日期、信贷客户风险评级到期日期】，原字段逻辑并无取值来源
                            2.调整【收支方式代码】成默认值"-"，原字段逻辑即为"-"
                            3.调整【开户机构编号、开户渠道代码、创建渠道代码、客户级别代码、客户状态代码、企业年收入、行业门类代码、行业类型代码_征信、联系电话_征信、国民经济部门类型代码、行业五级分类代码、行业信用评级代码、经济组织形式代码、股票代码、登记注册代码、企业登记注册类型、战略性新兴产业分类代码、开办资金、自证声明标志、税收机构类别代码、税收居民国家代码、税收居民身份代码、基本账户开户行名称、纳税人识别号、纳税人识别号空值原因描述、办理税务登记证标志、国家重点企业标志、科技型企业分类代码、科技型企业认定日期、居民标志、境内外标志、生产经营地址、生产经营地址邮政编码、经营所在地行政区划代码、所有制类型代码】成仅取ECIF
                            4.调整【信贷客户类型代码、企业成长阶段代码、绿色信贷分类代码、政府融资平台标志、首贷日期、企业身份标识类型代码、主要出资人个数、实际控制人个数、财务部门联系电话】成仅取信贷
            20230907 徐子豪 调整第一组左关联表存在重复的别名,以新别名替代。
            20231008 陈伟峰 调整第一组【联系电话_征信】取数逻辑，取TEL_TYPE_CD ='03'
            20231130 陈伟峰 添加客户号cust_id空值检查
            20231215 饶雅   调整【国税登记证号码、地税登记证号码】取数逻辑，仅取生效的数据
            20231227 陈伟峰 调整【企业身份标识类型代码、企业成长阶段代码、限制或鼓励行业代码、劳动密集型标志、上市公司类型代码】字段取数逻辑，因信贷不维护，调整成仅取ECIF
                            调整【组织机构类型代码】ECIF部分的取数逻辑，从默认值'00'调整为取t01_corp_cust_info.org_type_cd
            20240625 陈伟峰 调整【注册资本】取数逻辑，不再取信贷来源，仅取ECIF来源
			20250120 谢  宁 调整【EDU_HEA_FLG 文教健康标志】【RELA_GROUP_TYPE_CD 关联集团类型代码】EIFS组别取数逻辑
			20250428 陈  凭 1.新增字段【绿色信贷分类_新版代码】
                            2.修改字段名称：绿色信贷分类代码--》绿色信贷分类_旧版代码
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_corp_cust_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_corp_cust_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_corp_cust_basic_info_ex purge;
drop table ${icl_schema}.cmm_corp_cust_basic_info_ex01 purge;
drop table ${icl_schema}.cmm_corp_cust_basic_info_ex02 purge;
drop table ${icl_schema}.tmp_cmm_corp_cust_basic_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_corp_cust_basic_info_02 purge;

create table ${icl_schema}.cmm_corp_cust_basic_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_cust_basic_info where 0=1;

create table ${icl_schema}.cmm_corp_cust_basic_info_ex01
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_cust_basic_info where 0=1;

create table ${icl_schema}.cmm_corp_cust_basic_info_ex02
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_corp_cust_basic_info where 0=1;

--第一组（共四组）ecif对公客户信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_basic_info_ex01(
   etl_dt                                                       -- 数据日期
   ,lp_id                                                       -- 法人编号
   ,cust_id                                                     -- 客户编号
   ,cust_name                                                   -- 客户名称
   ,cust_en_name                                                -- 客户英文名称
   ,cust_kind_cd						                        -- 客户种类代码
   ,open_acct_dt                                                -- 开户日期
   ,belong_org_id                                               -- 所属机构编号
   ,open_acct_org_id                                            -- 开户机构编号
   ,anti_mon_lau_belong_org_id                                  -- 反洗钱归属机构编号
   ,open_acct_teller_id                                         -- 开户柜员编号
   ,open_acct_chn_cd                                            -- 开户渠道代码
   ,create_chn_cd                                               -- 创建渠道代码
   ,cust_mgr_id                                                 -- 客户经理编号
   ,cust_type_cd                                                -- 客户类型代码
   ,crdt_cust_type_cd					                        -- 信贷客户类型代码
   ,cust_lev_cd                                                 -- 客户级别代码
   ,depositr_cate_cd					                        -- 存款人类别代码
   ,bal_pay_way_cd                                              -- 收支方式代码
   ,cust_status_cd                                              -- 客户状态代码
   ,corp_anl_inco                                               -- 企业年收入
   ,corp_year_bus_lmt                                           -- 企业年营业额
   ,corp_found_dt                                               -- 企业成立日期
   ,corp_size_cd                                                -- 企业规模代码
   ,indus_categy_cd                                             -- 行业门类代码
   ,indus_type_cd                                               -- 行业类型代码
   ,indus_type_cd_crdtc                                         -- 行业类型代码_征信
   ,phone_crdtc                                                 -- 联系电话_征信
   ,corp_type_cd                                                -- 企业类型代码
   ,cty_rg_cd                                                   -- 国家和行政区划代码
   ,rg_cd                                                       -- 行政区划代码
   ,econ_char_cd                                                -- 经济性质代码
   ,econ_type_cd                                                -- 经济类型代码
   ,orgnz_cd                                                    -- 组织机构代码
   ,orgnz_type_cd                                               -- 组织机构类型代码
   ,natnal_econ_dept_type_cd                                    -- 国民经济部门类型代码
   ,indus_level5_cls_cd                                         -- 行业五级分类代码
   ,indus_crdt_rating_cd                                        -- 行业信用评级代码
   ,soci_crdt_cd                                                -- 社会信用代码
   ,bus_lics_num                                                -- 营业执照号
   ,bus_lics_exp_dt                                             -- 营业执照到期日期
   ,nation_tax_rgst_cert_num                                    -- 国税登记证号码
   ,local_tax_rgst_cert_num                                     -- 地税登记证号码
   ,fin_lics_num						                        -- 金融许可证号
   ,pbc_pay_bank_no						                        -- 人行支付行号
   ,econ_orgnz_form_cd                                          -- 经济组织形式代码
   ,loan_card_no                                                -- 贷款卡号
   ,stock_cd                                                    -- 股票代码
   ,oper_range                                                  -- 经营范围
   ,emply_qtty                                                  -- 企业员工人数
   ,curr_cd                                                     -- 币种代码
   ,rgst_cap                                                    -- 注册资金
   ,rgst_addr                                                   -- 注册地址
   ,rgst_dt                                                     -- 注册日期
   ,rgstion_cd                                                  -- 登记注册代码
   ,mang_field_prop_cd                                          -- 经营场地所有权代码
   ,corp_rgstion_type                                           -- 企业登记注册类型
   ,paid_in_capital                                             -- 实收资本
   ,paid_in_capital_curr_cd                                     -- 实收资本币种
   ,invtor_cty_cd                                               -- 投资方国家代码
   ,mang_field_area                                             -- 经营场地面积
   ,asset_tot                                                   -- 资产总额
   ,net_asset_tot                                               -- 净资产总额
   ,single_lp_flg                                               -- 独立法人标志
   ,high_new_tech_corp_flg                                      -- 高新技术企业标志
   ,rela_party_flg                                              -- 关联方标志
   ,rela_group_type_cd                                          -- 关联集团类型代码
   ,lp_org_name                                                 -- 法人机构名称
   ,lp_org_type_cd                                              -- 法人机构类型代码
   ,lp_org_cust_id                                              -- 法人机构客户编号
   ,group_cust_flg                                              -- 集团客户标志
   ,cbrc_sb_flg                                                 -- 银监小企业标志
   ,labor_inte_flg                                              -- 劳动密集型标志
   ,hold_type_cd                                                -- 控股类型代码
   ,off_shore_cust_flg                                          -- 离岸客户标志
   ,prit_etp_flg                                                -- 民营企业标志
   ,ctysd_corp_flg                                              -- 农村企业标志
   ,corp_grow_stage_cd                                          -- 企业成长阶段代码
   ,list_corp_type_cd                                           -- 上市公司类型代码
   ,strate_new_indus_cls_cd                                     -- 战略性新兴产业分类代码
   ,list_corp_flg                                               -- 上市公司标志
   ,strtg_cust_flg                                              -- 战略客户标志
   ,open_cap                                                    -- 开办资金
   ,crdt_cust_flg                                               -- 授信客户标志
   ,stament_flg                                                 -- 自证声明标志
   ,tax_org_cate_cd                                             -- 税收机构类别代码
   ,tax_resdnt_cty_cd                                           -- 税收居民国家代码
   ,tax_resdnt_idti_cd                                          -- 税收居民身份代码
   ,basic_acct_open_bank_name                                   -- 基本账户开户行名称
   ,basic_acct_acct_num                                         -- 基本账户账号
   ,tax_num								                        -- 纳税人识别号
   ,tax_num_null_rs_descb			                            -- 纳税人识别号空值原因描述
   ,bel_thi_flg                                                 -- 属于两高行业标志
   ,trast_tax_regi_cert_flg                                     -- 办理税务登记证标志
   ,cty_key_enterp_flg                                          -- 国家重点企业标志
   ,group_corp_flg                                              -- 集团客户标志二
   ,group_cust_id                                               -- 集团客户编号
   ,group_type_cd                                               -- 集团类型代码
   ,group_parent_corp_id                                        -- 集团母公司编号
   ,lmt_or_encrge_indus_cd                                      -- 限制或鼓励行业代码
   ,have_bod_flg                                                -- 有董事会标志
   ,green_crdt_cust_flg                                         -- 绿色信贷客户标志
   ,green_crdt_cls_cd                                           -- 绿色信贷分类_旧版代码
   ,green_crdt_cls_new                                          -- 绿色信贷分类_新版代码
   ,sci_tech_corp_cls_cd                                        -- 科技型企业分类代码
   ,sci_tech_corp_idtfy_dt                                      -- 科技型企业认定日期
   ,edu_hea_flg							                        -- 文教健康标志
   ,inc_flg                                                     -- 普惠标志
   ,araf_flg                                                    -- 三农标志
   ,is_mx_mgmt_righ_flg                                         -- 有无进出口经营权标志
   ,escp_debt_corp_flg                                          -- 逃废债企业标志
   ,is_mx_oper_item_flg                                         -- 有无进出口经营项标志
   ,resdnt_flg       					                        -- 居民标志
   ,dom_overs_flg                                               -- 境内外标志
   ,green_bond_proj_flg                                         -- 绿色债券项目标志
   ,work_addr        					                        -- 办公地址
   ,work_addr_zip_cd 					                        -- 办公地址邮政编码
   ,posta_addr       					                        -- 通讯地址
   ,posta_addr_zip_cd					                        -- 通讯地址邮政编码
   ,prod_mang_addr       				                        -- 生产经营地址
   ,prod_mang_addr_zip_cd				                        -- 生产经营地址邮政编码
   ,mang_site_cd                                                -- 经营所在地行政区划代码
   ,crdt_cust_risk_rating_cd      		                        -- 信贷客户风险评级代码
   ,crdt_cust_risk_rating_start_dt		                        -- 信贷客户风险评级开始日期
   ,crdt_cust_risk_rating_exp_dt  		                        -- 信贷客户风险评级到期日期
   ,ownsp_type_cd                 		                        -- 所有制类型代码
   ,dep_class_cust_flg                                          -- 存款类客户标志
   ,loan_class_cust_flg                                         -- 信贷客户标志代码
   ,guar_class_cust_flg                                         -- 担保客户标志代码
   ,corp_close_flg                		                        -- 企业关停标志
   ,gover_fin_plat_flg                                          -- 政府融资平台标志
   ,short_check_blklist_flg                                     -- 空头支票黑名单标志
   ,fir_lon_dt							                        -- 首贷日期
   ,orgnz_surviv_status_cd	                                    -- 组织机构存续状态代码
   ,corp_idti_idf_type_cd	                                    -- 企业身份标识类型代码
   ,major_contrior_cnt	                                        -- 主要出资人个数
   ,actl_ctrler_cnt	                                            -- 实际控制人个数
   ,fin_dept_phone	                                            -- 财务部门联系电话
   ,job_cd                                                      -- 任务代码
   ,etl_timestamp                                               -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                          -- 数据日期
   ,t1.lp_id                                                    -- 法人编号
   ,t1.party_id                 				                -- 客户编号
   ,t1.corp_name                				                -- 客户名称
   ,t1.corp_en_name      								        -- 客户英文名称
   ,decode(t1.corp_party_type_cd,'2','PUBLIC_TYPE'
           ,'3','SAME_TRADE_TYPE','PUBLIC_TYPE'
           )				     								-- 客户种类代码
   ,t2.effect_dt 						                        -- 开户日期
   ,t1.org_subj       				                            -- 所属机构编号
   ,t30.open_acct_org_id                                        -- 开户机构编号
   ,t47.cust_belong_org                                         -- 反洗钱归属机构编号
   ,t30.open_acct_user_id        				                -- 开户柜员编号
   ,t47.init_system_id 									        -- 开户渠道代码
   ,nvl(trim(t47.init_system_id),'-')                           -- 创建渠道代码
   ,t6.rela_party_id										    -- 客户经理编号
   ,t1.corp_party_type_cd                                       -- 客户类型代码
   ,''										                    -- 信贷客户类型代码
   ,t1.cust_lev_cd     						                    -- 客户级别代码
   ,t1.depositr_cate_cd						                    -- 存款人类别代码
   ,'-'  									                    -- 收支方式代码
   ,t7.party_status_cd						                    -- 客户状态代码
   ,t8.anl_inco    							                    -- 企业年收入
   ,t8.tot_sell_lmt 						                    -- 企业年营业额
   ,t1.corp_found_dt        				                    -- 企业成立日期 t15.found_dt   modify by xn20210621
   ,case when t1.corp_size_cd in ('1','2','3','4')
         then t1.corp_size_cd else '0' end                      -- 企业规模代码
   ,decode(t26.belong_indus_acct, 'U', 'T', t26.belong_indus_acct) -- 行业门类代码
   ,decode(t1.indus_type_cd_crdtc, '-', t48.indus_type_cd_nat_stan, t1.indus_type_cd_crdtc) as indus_type_cd  -- 行业类型代码
   ,t1.indus_type_cd_crdtc									    -- 行业类型代码_征信
   ,t9.tel_num												    -- 联系电话_征信
   ,t1.corp_type_cd                                             -- 企业类型代码
   ,t1.cty_rg_cd               							        -- 国家和行政区划代码
   ,t1.rg_cd                   							        -- 行政区划代码
   ,t1.econ_char_cd            							        -- 经济性质代码
   ,t1.econ_type_cd                  				            -- 经济类型代码
   ,t10.cert_num								                -- 组织机构代码
   ,t1.orgnz_type_subdv_cd                                      -- 组织机构类型代码
   ,case when trim(t1.natnal_econ_dept_type_cd)	is null
         then '000'
         else t1.natnal_econ_dept_type_cd end	                -- 国民经济部门类型代码
   ,t1.indus_type_cd_level5_cls			  			            -- 行业五级分类代码
   ,t1.indus_type_cd_crdt_rating					            -- 行业信用评级代码
   ,trim(t1.soci_crdt_cd)				                        -- 社会信用代码
   ,trim(t13.cert_num)						                    -- 营业执照号
   ,nvl(t13.cert_invalid_dt,to_date('29991231','yyyymmdd'))     -- 营业执照到期日期
   ,t27.cert_num				                		        -- 国税登记证号码
   ,t28.cert_num				                		        -- 地税登记证号码
   ,t14.fin_lics_num						                    -- 金融许可证号
   ,t14.ibank_no								                -- 人行支付行号
   ,t1.econ_orgnz_form_cd  			                            -- 经济组织形式代码
   ,t1.loan_card_no                                             -- 贷款卡号
   ,t1.stock_cd                                                 -- 股票代码
   ,t1.oper_range     					                        -- 经营范围
   ,t1.emply_qtty     					                        -- 企业员工人数
   ,t1.curr_cd        					                        -- 币种代码
   ,t1.rgst_cap       					                        -- 注册资金
   ,t39.cont_addr     					                        -- 注册地址
   ,t1.rgst_dt					                		        -- 注册日期
   ,t15.rgst_cd   					                            -- 登记注册代码
   ,t15.oper_field_prop_cd          					        -- 经营场地所有权代码
   ,t15.corp_rgst_type_cd   					                -- 企业登记注册类型
   ,t15.paid_in_capital					                        -- 实收资本
   ,t15.paid_in_capital_curr_cd                                 -- 实收资本币种
   ,t1.cty_rg_cd  	                					        -- 投资方国家代码
   ,t15.oper_field_area	                			            -- 经营场地面积
   ,t15.asset_tot	                						    -- 资产总额
   ,t8.net_asset	                						    -- 净资产总额
   ,t16.attr_val	                						    -- 独立法人标志
   ,t33.attr_val                							    -- 高新技术企业标志
   ,t17.attr_val	                						    -- 关联方标志
   ,t58.group_cust_type_cd	                		            -- 关联集团类型代码
   ,t1.lp_org_name                                              -- 法人机构名称
   ,t1.lp_org_type_cd                                           -- 法人机构类型代码
   ,t1.lp_org_cust_id                                           -- 法人机构客户编号
   ,case when trim(t55.party_id) is not null then '1' else '0' end   -- 集团客户标志
   ,nvl(trim(t1.cbrc_sb_flg),'0')       	                	    -- 银监小企业标志
   ,t56.attr_val                 							    -- 劳动密集型标志
   ,t1.econ_orgnz_form_cd                 						-- 控股类型代码
   ,nvl(trim(t1.off_shore_cust_flg),'0')                	    -- 离岸客户标志
   ,t18.attr_val                							    -- 民营企业标志
   ,t41.attr_val                                                -- 农村企业标志
   ,''	              											-- 企业成长阶段代码
   ,t1.list_corp_type_cd                					    -- 上市公司类型代码
   ,decode(t48.new_str_eme,'1','2',
                 '2','4','3','6','4','3',
                 '5','7','6','5','7','1',
                 '8','8','9','9',t48.new_str_eme)               -- 战略性新兴产业分类代码
   ,nvl(trim(t1.list_corp_flg),'0')                			    -- 上市公司标志
   ,t46.attr_val                                                -- 战略客户标志
   ,t1.open_cap                 								-- 开办资金
   ,t19.attr_val           										-- 授信客户标志
   ,nvl(trim(t1.tax_stament_flg),'0')                			-- 自证声明标志
   ,t1.tax_org_cate_cd                  					    -- 税收机构类别代码
   ,t1.tax_resdnt_cty_cd                 					    -- 税收居民国家代码
   ,t1.tax_resdnt_idti_cd                 					    -- 税收居民身份代码
   ,t42.basic_open_bank_name                                    -- 基本账户开户行名称
   ,t42.basic_acct_id                                           -- 基本账户账号
   ,t1.taxpayer_idtfy_num                						-- 纳税人识别号
   ,t1.tax_num_null_rs_descb                					-- 纳税人识别号空值原因描述
   ,nvl(trim(t1.bel_thi_flg),'0')                				-- 属于两高行业标志
   ,nvl(trim(t1.trast_tax_regi_cert_flg), '0')                	-- 办理税务登记证标志
   ,nvl(trim(t1.cty_key_enterp_flg),'')                			-- 国家重点企业标志
   ,case when trim(t55.party_id) is not null then '1' else null end  -- 集团客户标志二
   ,t22.belong_group_id  										     -- 集团客户编号
   ,''                                                          -- 集团类型代码
   ,bl.party_id                              	                -- 集团母公司编号
   ,t1.lmt_or_encrge_indus_cd                					-- 限制或鼓励行业代码
   ,'0'                                			                -- 有董事会标志
   ,nvl(trim(t20.attr_val),'0')                					-- 绿色信贷客户标志
   ,'-'                                                         -- 绿色信贷分类_旧版代码
   ,'-'                                                         -- 绿色信贷分类_新版代码
   ,t43.attr_val                                                -- 科技型企业分类代码
   ,t44.imp_dt                                                  -- 科技型企业认定日期
   ,t57.attr_val                								-- 文教健康标志
   ,''                											-- 普惠标志
   ,''               					                        -- 三农标志
   ,d13.attr_val                			                    -- 有无进出口经营权标志nvl(trim(d12.is_mx_mgmt_righ_flg),'0')  modify by xn20210621
   ,nvl(trim(d12.escp_debt_corp_flg),'0')  	                	-- 逃废债企业标志
   ,nvl(trim(d12.is_mx_oper_item_flg),'0')  	                -- 有无进出口经营项标志
   ,decode(t1.resdnt_flg,'-','1',t1.resdnt_flg)	                -- 居民标志
   ,t40.attr_val                                                -- 境内外标志
   ,''                                                          -- 绿色债券项目标志
   ,nvl(trim(t23.phys_addr),trim(t23.cont_addr))	      		-- 办公地址
   ,t23.zip_cd		      										-- 办公地址邮政编码
   ,nvl(trim(t24.phys_addr),trim(t24.cont_addr))		      	-- 通讯地址
   ,t24.zip_cd	      											-- 通讯地址邮政编码
   ,nvl(trim(t25.phys_addr),trim(t25.cont_addr))       	        -- 生产经营地址
   ,t25.zip_cd					                                -- 生产经营地址邮政编码
   ,t1.mang_site_dist_cd                                        -- 经营所在地行政区划代码
   ,''	               											-- 信贷客户风险评级代码
   ,''	               							                -- 信贷客户风险评级开始日期
   ,''	               							                -- 信贷客户风险评级到期日期
   ,t48.owner_type	               								-- 所有制类型代码
   ,tb.aml_dep_flag                                             -- 存款类客户标志
   ,tb.aml_loan_flag                                            -- 贷款类客户标志
   ,tb.aml_guar_flag                                            -- 担保类客户标志
   ,decode(t48.org_status_cd, '2', '1', '1', '0', '-')	     	-- 企业关停标志
   ,'0'	                										-- 政府融资平台标志
   ,t37.bad_check_black                       	                -- 空头支票黑名单标志
   ,to_date('29991231','yyyymmdd')							    -- 首贷日期
   ,t7.party_status_cd                                          -- 组织机构存续状态代码
   ,''                                                          -- 企业身份标识类型代码
   ,'0'                                                         -- 主要出资人个数
   ,'0'                                                         -- 实际控制人个数
   ,'' 	                                                        -- 财务部门联系电话
   ,t1.job_cd                                                   -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')      --etl处理时间戳
from ${iml_schema}.pty_corp t1
left join ${iml_schema}.pty_party t2
  on t1.party_id = t2.party_id
 and t2.party_type_cd in('301004','301005')  --公司、同业
 and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'eifsf1'
 and t2.id_mark <> 'D'
left join ${iml_schema}.pty_party_rela_h t6
  on t1.party_id = t6.party_id
 and t6.party_rela_type_cd ='dw003'
 and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t6.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_status_h t7
  on t1.party_id = t7.party_id
 and t7.party_status_type_cd ='CD1271'
 and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t7.job_cd = 'eifsf1'
left join ${iml_schema}.pty_corp_oper_situ_h t8    ---净资产
  on t1.party_id =t8.party_id
 and t8.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t8.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t8.job_cd = 'eifsf1'
left join ${iml_schema}.pty_tel_info_h t9
  on t1.party_id = t9.party_id
 and t9.tel_type_cd = '03'   
 and t9.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t9.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t9.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_cert_info_h t10
  on t1.party_id = t10.party_id
 and t10.sorc_sys_cd = 'EIFS'
 and t10.cert_type_cd = '2020' --组织机构代码
 and t10.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t10.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t10.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_cert_info_h t27
  on t1.party_id = t27.party_id
 and t27.sorc_sys_cd = 'EIFS'
 and t27.cert_type_cd = '2071' --国税证件号
 and t27.cert_valid_flg ='1'
 and t27.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t27.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t27.job_cd = 'eifsf1'
left join  ${iml_schema}.pty_party_cert_info_h t28
  on t1.party_id = t28.party_id
 and t28.sorc_sys_cd = 'EIFS'
 and t28.cert_type_cd = '2072' --地税证件号
 and t28.cert_valid_flg ='1'
 and t28.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t28.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t28.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_cert_info_h t13
  on t1.party_id = t13.party_id
 and t13.sorc_sys_cd = 'EIFS'
 and t13.cert_type_cd = '2010' --营业执照
 and t13.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t13.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t13.job_cd = 'eifsf1'
left join ${iml_schema}.pty_ibank_cust_chat_info t14  --同业证件
  on t1.party_id = t14.party_id
 and t14.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t14.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t14.job_cd = 'eifsf1'
left join ${iml_schema}.pty_corp_rgst_info_h t15
  on t1.party_id = t15.party_id
 and t15.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t15.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t15.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t16
  on t1.party_id = t16.party_id
 and t16.attr_name ='C0004'
 and t16.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t16.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t16.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t17
  on t1.party_id = t17.party_id
 and t17.attr_name ='C0018'
 and t17.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t17.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t17.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t18
  on t1.party_id = t18.party_id
 and t18.attr_name ='C0005'
 and t18.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t18.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t18.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t33  --高新技术标志
  on t1.party_id = t33.party_id
 and t33.attr_name ='C0021'
 and t33.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t33.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t33.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t19
  on t1.party_id = t19.party_id
 and t19.attr_name ='C0007'
 and t19.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t19.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t19.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t20
  on t1.party_id = t20.party_id
 and t20.attr_name ='C0015'
 and t20.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t20.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t20.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t21
  on t1.party_id = t21.party_id
 and t21.attr_name ='C0014'
 and t21.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t21.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t21.job_cd = 'eifsf1'
left join (select h.party_id,
                  h.lp_id,
                  h.belong_group_id,
                  h.data_src_cd,
                  row_number() over(partition by party_id, lp_id order by data_src_cd desc) rn
             from ${iml_schema}.pty_corp_cust_group_info_h h
            where h.start_dt <= to_date('${batch_date}','yyyymmdd')
              and h.end_dt > to_date('${batch_date}','yyyymmdd')
              and h.job_cd in('eifsf1','icmsf1')
			  and h.mem_status_cd = '0'-- 1解散 0正常
			  ) t22
  on t1.party_id = t22.party_id
 and t1.lp_id = t22.lp_id
 and t22.rn = 1
left join (select h.party_id,
                  h.lp_id,
                  h.belong_group_id,
                  h.data_src_cd,
                  row_number() over(partition by belong_group_id, lp_id order by data_src_cd desc) rn
             from ${iml_schema}.pty_corp_cust_group_info_h h
            where h.start_dt <= to_date('${batch_date}','yyyymmdd')
              and h.end_dt > to_date('${batch_date}','yyyymmdd')
              and h.job_cd in('eifsf1','icmsf1')
              and h.mem_type_cd = '1'    --母公司
			  ) bl
  on t22.belong_group_id = bl.belong_group_id
 and t22.lp_id = bl.lp_id
 and bl.rn = 1
left join ${iml_schema}.pty_party_phys_addr_h t23
  on t1.party_id = t23.party_id
 and t23.phys_addr_type_cd = '06'   --办公地址
 and t23.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t23.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t23.job_cd = 'eifsf1'
 and t23.src_table_name = 'eifs_t03_corp_addr_info'
left join ${iml_schema}.pty_party_phys_addr_h t39
  on t1.party_id = t39.party_id
 and t39.phys_addr_type_cd = '05'   --注册地址
 and t39.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t39.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t39.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_phys_addr_h t24
  on t1.party_id = t24.party_id
 and t24.phys_addr_type_cd = '03'   --通讯地址
 and t24.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t24.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t24.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_phys_addr_h t25
  on t1.party_id = t25.party_id
 and t25.phys_addr_type_cd = '21'   --生产经营地址
 and t25.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t25.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t25.job_cd = 'eifsf1'
left join (select t2.cust_num as party_id,t1.create_te,t1.init_system_id,t1.belong_indus_acct
              from ${iol_schema}.eifs_t01_corp_cust_info t1
              left join ${iol_schema}.eifs_t00_corp_cust_no_ref t2
                on t1.party_id = t2.party_id
               and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
             where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
               and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
               and to_date(to_char(t1.updated_ts,'yyyymmdd'),'yyyymmdd')> to_date('${batch_date}','yyyymmdd')) t26
  on t1.party_id=t26.party_id
left join ${iml_schema}.pty_cust t30
  on t1.party_id = t30.party_id
 and t30.sorc_sys_cd = 'EIFS'
 and t30.create_dt <= to_date('${batch_date}','yyyymmdd')
 and t30.job_cd = 'eifsf1'
 and t30.id_mark <> 'D'
left join (select cust_no as cust_id,
                  bad_check_black,
                  glob_seq_num,
                  task_id,
                  row_number() over(partition by cust_no order by task_id desc) rn
             from iol.scps_bp_corporate_tb t
            where trim(cust_no) is not null
              and start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and end_dt > to_date('${batch_date}', 'yyyymmdd')) t37
  on t37.cust_id =t1.party_id
 and t37.rn =1
left join ${iml_schema}.pty_corp_cust d12
  on t1.party_id = d12.cust_id
 and d12.create_dt <= to_date('${batch_date}','yyyymmdd')
 and d12.job_cd = 'icmsf1'
 and d12.id_mark <> 'D'
left join ${iml_schema}.pty_party_attr_h d13
  on t1.party_id = d13.party_id
 and d13.attr_name = 'C0030'    --进出口
 and d13.start_dt <= to_date('${batch_date}','yyyymmdd')
 and d13.end_dt > to_date('${batch_date}','yyyymmdd')
 and d13.job_cd ='eifsf1'
left join ${iml_schema}.pty_party_attr_h t40
  on t1.party_id = t40.party_id
 and t40.attr_name='B0002'
 and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t40.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t41
  on t1.party_id = t41.party_id
 and t41.attr_name ='C0024'
 and t41.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t41.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t41.job_cd = 'eifsf1'
left join ${iml_schema}.pty_corp_bank_acct_info_h t42
  on t1.party_id=t42.party_id
 and t42.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t42.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t42.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t43
  on t1.party_id = t43.party_id
 and t43.attr_name ='B0005'
 and t43.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t43.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t43.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_imp_dt_h t44
  on t1.party_id = t44.party_id
 and t44.imp_dt_type_cd ='74'
 and t44.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t44.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t44.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_phys_addr_h t45
  on t1.party_id = t45.party_id
 and t45.phys_addr_type_cd = '06'   --客户经营地址
 and t45.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t45.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t45.job_cd = 'eifsf1'
 and t45.src_table_name ='eifs_t00_party_pub_info'
left join ${iml_schema}.pty_party_attr_h t46
  on t1.party_id = t46.party_id
 and t46.attr_name='C0035'
 and t46.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t46.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t46.job_cd = 'eifsf1'
left join ${iol_schema}.eifs_t00_party_pub_info t47
  on t1.party_id = t47.cust_num
 and t47.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t47.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.eifs_t01_corp_cust_info tb
  on t47.party_id = tb.party_id
 and tb.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and tb.end_dt   > to_date('${batch_date}', 'yyyymmdd')
left join ${iol_schema}.eifs_t01_corp_cust_ext_info t48
  on t47.party_id = t48.party_id
 and t48.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t48.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t48.updated_ts =to_date('99991231', 'yyyymmdd')
left join (select  party_id as party_id
                  ,row_number() over(partition by party_id order by belong_group_id desc) rn
             from ${iml_schema}.pty_corp_cust_group_info_h
            where start_dt <= to_date('${batch_date}', 'yyyymmdd')
              and end_dt > to_date('${batch_date}', 'yyyymmdd')
              and job_cd ='eifsf1'
              and mem_status_cd = '0') t55
  on t1.party_id = t55.party_id
 and t55.rn = 1
left join ${iml_schema}.pty_party_attr_h t56
  on t1.party_id = t56.party_id
 and t56.attr_name='C0037'   --公司客户-是否劳动密集型企业
 and t56.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t56.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t56.job_cd = 'eifsf1'
 left join ${iml_schema}.pty_party_attr_h t57
  on t1.party_id = t57.party_id
 and t57.attr_name ='C0016'
 and t57.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t57.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t57.job_cd = 'eifsf1'
 left join ${iml_schema}.pty_group_party t58
  on t22.belong_group_id = t58.party_id
 and t58.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t58.id_mark <> 'D'
 and t58.job_cd='eifsf1'
where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t1.job_cd = 'eifsf1'
 and t1.corp_party_type_cd in ('2','4','3');
-- and t1.corp_party_type_cd in ('21','18','24','25');
commit;

--第二组（共四组）公司集团信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_basic_info_ex01(
   etl_dt                                -- 数据日期
   ,lp_id                                -- 法人编号
   ,cust_id                              -- 客户编号
   ,cust_name                            -- 客户名称
   ,cust_en_name                         -- 客户英文名称
   ,cust_kind_cd						 -- 客户种类代码
   ,open_acct_dt                         -- 开户日期
   ,belong_org_id                        -- 所属机构编号
   ,open_acct_org_id                     -- 开户机构编号
   ,anti_mon_lau_belong_org_id           -- 反洗钱归属机构编号
   ,open_acct_teller_id                  -- 开户柜员编号
   ,open_acct_chn_cd                     -- 开户渠道代码
   ,create_chn_cd                        -- 创建渠道代码
   ,cust_mgr_id                          -- 客户经理编号
   ,cust_type_cd                         -- 客户类型代码
   ,crdt_cust_type_cd					 -- 信贷客户类型代码
   ,cust_lev_cd                          -- 客户级别代码
   ,depositr_cate_cd					 -- 存款人类别代码
   ,bal_pay_way_cd                       -- 收支方式代码
   ,cust_status_cd                       -- 客户状态代码
   ,corp_anl_inco                        -- 企业年收入
   ,corp_year_bus_lmt                    -- 企业年营业额
   ,corp_found_dt                        -- 企业成立日期
   ,corp_size_cd                         -- 企业规模代码
   ,indus_categy_cd                      -- 行业门类代码
   ,indus_type_cd                        -- 行业类型代码
   ,indus_type_cd_crdtc                  -- 行业类型代码_征信
   ,phone_crdtc                          -- 联系电话_征信
   ,corp_type_cd                         -- 企业类型代码
   ,cty_rg_cd                            -- 国家和行政区划代码
   ,rg_cd                                -- 行政区划代码
   ,econ_char_cd                         -- 经济性质代码
   ,econ_type_cd                         -- 经济类型代码
   ,orgnz_cd                             -- 组织机构代码
   ,orgnz_type_cd                        -- 组织机构类型代码
   ,natnal_econ_dept_type_cd             -- 国民经济部门类型代码
   ,indus_level5_cls_cd                  -- 行业五级分类代码
   ,indus_crdt_rating_cd                 -- 行业信用评级代码
   ,soci_crdt_cd                         -- 社会信用代码
   ,bus_lics_num                         -- 营业执照号
   ,bus_lics_exp_dt                      -- 营业执照到期日期
   ,nation_tax_rgst_cert_num             -- 国税登记证号码
   ,local_tax_rgst_cert_num              -- 地税登记证号码
   ,fin_lics_num						 -- 金融许可证号
   ,pbc_pay_bank_no						 -- 人行支付行号
   ,econ_orgnz_form_cd                   -- 经济组织形式代码
   ,loan_card_no                         -- 贷款卡号
   ,stock_cd                             -- 股票代码
   ,oper_range                           -- 经营范围
   ,emply_qtty                           -- 企业员工人数
   ,curr_cd                              -- 币种代码
   ,rgst_cap                             -- 注册资金
   ,rgst_addr                            -- 注册地址
   ,rgst_dt                              -- 注册日期
   ,rgstion_cd                           -- 登记注册代码
   ,mang_field_prop_cd                   -- 经营场地所有权代码
   ,corp_rgstion_type                    -- 企业登记注册类型
   ,paid_in_capital                      -- 实收资本
   ,paid_in_capital_curr_cd              -- 实收资本币种
   ,invtor_cty_cd                        -- 投资方国家代码
   ,mang_field_area                      -- 经营场地面积
   ,asset_tot                            -- 资产总额
   ,net_asset_tot                        -- 净资产总额
   ,single_lp_flg                        -- 独立法人标志
   ,high_new_tech_corp_flg               -- 高新技术企业标志
   ,rela_party_flg                       -- 关联方标志
   ,rela_group_type_cd                   -- 关联集团类型代码
   ,lp_org_name                          -- 法人机构名称
   ,lp_org_type_cd                       -- 法人机构类型代码
   ,lp_org_cust_id                       -- 法人机构客户编号
   ,group_cust_flg                       -- 集团客户标志
   ,cbrc_sb_flg                          -- 银监小企业标志
   ,labor_inte_flg                       -- 劳动密集型标志
   ,hold_type_cd                         -- 控股类型代码
   ,off_shore_cust_flg                   -- 离岸客户标志
   ,prit_etp_flg                         -- 民营企业标志
   ,ctysd_corp_flg                       -- 农村企业标志
   ,corp_grow_stage_cd                   -- 企业成长阶段代码
   ,list_corp_type_cd                    -- 上市公司类型代码
   ,strate_new_indus_cls_cd              -- 战略性新兴产业分类代码
   ,list_corp_flg                        -- 上市公司标志
   ,strtg_cust_flg                       -- 战略客户标志
   ,open_cap                             -- 开办资金
   ,crdt_cust_flg                        -- 授信客户标志
   ,stament_flg                          -- 自证声明标志
   ,tax_org_cate_cd                      -- 税收机构类别代码
   ,tax_resdnt_cty_cd                    -- 税收居民国家代码
   ,tax_resdnt_idti_cd                   -- 税收居民身份代码
   ,basic_acct_open_bank_name            -- 基本账户开户行名称
	 ,basic_acct_acct_num                -- 基本账户账号
   ,tax_num								 -- 纳税人识别号
   ,tax_num_null_rs_descb			     -- 纳税人识别号空值原因描述
   ,bel_thi_flg                          -- 属于两高行业标志
   ,trast_tax_regi_cert_flg              -- 办理税务登记证标志
   ,cty_key_enterp_flg                   -- 国家重点企业标志
   ,group_corp_flg                       -- 集团客户标志二
   ,group_cust_id                        -- 集团客户编号
   ,group_type_cd                        -- 集团类型代码
   ,group_parent_corp_id                 -- 集团母公司编号
   ,lmt_or_encrge_indus_cd               -- 限制或鼓励行业代码
   ,have_bod_flg                         -- 有董事会标志
   ,green_crdt_cust_flg                  -- 绿色信贷客户标志
   ,green_crdt_cls_cd                    -- 绿色信贷分类_旧版代码
   ,green_crdt_cls_new                   -- 绿色信贷分类_新版代码
   ,sci_tech_corp_cls_cd                 -- 科技型企业分类代码
   ,sci_tech_corp_idtfy_dt               -- 科技型企业认定日期
   ,edu_hea_flg							 -- 文教健康标志
   ,inc_flg                              -- 普惠标志
   ,araf_flg                             -- 三农标志
   ,is_mx_mgmt_righ_flg                  -- 有无进出口经营权标志
   ,escp_debt_corp_flg                   -- 逃废债企业标志
   ,is_mx_oper_item_flg                  -- 有无进出口经营项标志
   ,resdnt_flg       					 -- 居民标志
   ,dom_overs_flg                        -- 境内外标志
   ,green_bond_proj_flg                  -- 绿色债券项目标志
   ,work_addr        					 -- 办公地址
   ,work_addr_zip_cd 					 -- 办公地址邮政编码
   ,posta_addr       					 -- 通讯地址
   ,posta_addr_zip_cd					 -- 通讯地址邮政编码
   ,prod_mang_addr       				 -- 生产经营地址
   ,prod_mang_addr_zip_cd				 -- 生产经营地址邮政编码
   ,mang_site_cd                         -- 经营所在地行政区划代码
   ,crdt_cust_risk_rating_cd      		 -- 信贷客户风险评级代码
   ,crdt_cust_risk_rating_start_dt		 -- 信贷客户风险评级开始日期
   ,crdt_cust_risk_rating_exp_dt  		 -- 信贷客户风险评级到期日期
   ,ownsp_type_cd                 		 -- 所有制类型代码
   ,dep_class_cust_flg                   -- 存款类客户标志
   ,loan_class_cust_flg                  -- 信贷客户标志代码
   ,guar_class_cust_flg                  -- 担保客户标志代码
   ,corp_close_flg                		 -- 企业关停标志
   ,gover_fin_plat_flg                   -- 政府融资平台标志
   ,short_check_blklist_flg              -- 空头支票黑名单标志
   ,fir_lon_dt							 -- 首贷日期
   ,orgnz_surviv_status_cd	             -- 组织机构存续状态代码
   ,corp_idti_idf_type_cd	             -- 企业身份标识类型代码
   ,major_contrior_cnt	                 -- 主要出资人个数
   ,actl_ctrler_cnt	                     -- 实际控制人个数
   ,fin_dept_phone	                     -- 财务部门联系电话
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                               -- 数据日期
   ,t1.lp_id                                                         -- 法人编号
   ,t1.party_id								                         -- 客户编号
   ,t1.group_name                  									 -- 客户名称
   ,t1.group_en_name                     							 -- 客户英文名称
   ,'GROUP_TYPE'                      								 -- 客户种类代码
   ,to_date('00010101','yyyymmdd') 								     -- 开户日期
   ,t2.open_acct_org_id                                	             -- 所属机构编号
   ,t2.open_acct_org_id                                              -- 开户机构编号
   ,''                                                               -- 反洗钱归属机构编号
   ,'M0001'                               							 -- 开户柜员编号
   ,'100001'                                      				     -- 开户渠道代码
   ,nvl(trim(t47.init_system_id),'-')                                -- 创建渠道代码
   ,t1.cust_mgr_id                                 				     -- 客户经理编号
   ,'2'         									                 -- 客户类型代码
   --,'24'         									                 -- 客户类型代码
   ,'5'															     -- 信贷客户类型代码
   ,'0'                                          					 -- 客户级别代码
   ,'299'                                          				     -- 存款人类别代码
   ,'-'                                          					 -- 收支方式代码
   ,'1'                                          					 -- 客户状态代码
   ,''                             								     -- 企业年收入
   ,''                                 								 -- 企业年营业额
   ,to_date('00010101','yyyymmdd')  								 -- 企业成立日期
   ,'0'                                                              -- 企业规模代码
   ,''                                                               -- 行业门类代码
   ,'-'                                                              -- 行业类型代码
   ,'-'                                                              -- 行业类型代码_征信
   ,''                                                               -- 联系电话_征信
   ,'0'                                                              -- 企业类型代码
   ,t1.cty_rg_cd                                                     -- 国家和行政区划代码
   ,t1.work_land_dist_cd                                             -- 行政区划代码
   ,'000'                                                            -- 经济性质代码
   ,'9999'                                                           -- 经济类型代码
   ,''                                                               -- 组织机构代码
   ,''                                                               -- 组织机构类型代码
   ,'000'                                                            -- 国民经济部门类型代码
   ,'-'                                                              -- 行业五级分类代码
   ,'-'                                                              -- 行业信用评级代码
   ,''                                                               -- 统一社会信用代码
   ,''                                                               -- 营业执照号
   ,to_date('29991231','yyyymmdd')                                   -- 营业执照到期日期
   ,''                                                               -- 国税登记证号码
   ,''                                                               -- 地税登记证号码
   ,''                                                               -- 金融许可证号
   ,''																 -- 人行支付行号
   ,'Z9999'                                                          -- 经济组织形式代码
   ,''                                                               -- 贷款卡号
   ,''                                                               -- 股票代码
   ,''                                                               -- 经营范围
   ,''                                                               -- 企业员工人数
   ,'CNY'                                                            -- 币种代码
   ,''                                                               -- 注册资金
   ,''                                                               -- 注册地址
   ,to_date('00010101' ,'yyyymmdd')                                  -- 注册日期
   ,''								                                 -- 登记注册代码
   ,'0'                                                              -- 经营场地所有权代码
   ,'000'						                                     -- 企业登记注册类型
   ,''                                                               -- 实收资本
   ,'CNY'                                                            -- 实收资本币种
   ,''                                                               -- 投资方国家代码
   ,''                                                               -- 经营场地面积
   ,''                                                               -- 资产总额
   ,0                                                                -- 净资产总额
   ,'0'                                                              -- 独立法人标志
   ,'0'                                                              -- 高新技术企业标志
   ,'0'                                                              -- 关联方标志
   ,'-'                                                              -- 关联集团类型代码
   ,''                                                               -- 法人机构名称
   ,'-'                                                              -- 法人机构类型代码
   ,''                                                               -- 法人机构客户编号
   ,'0'                                                              -- 集团客户标志
   ,'0'                                                              -- 银监小企业标志
   ,'' 															     -- 劳动密集型标志
   ,''                                                               -- 控股类型代码
   ,'0'                                                              -- 离岸客户标志
   ,'0'                                                              -- 民营企业标志
   ,'0'                                                              -- 农村企业标志
   ,'' 																 -- 企业成长阶段代码
   ,'-'                                                              -- 上市公司类型代码
   ,'0'                                                              -- 战略性新兴产业分类代码
   ,'0'                                                              -- 上市公司标志
   ,''                                                               -- 战略客户标志
   ,''                                                               -- 开办资金
   ,'-'                                                              -- 授信客户标志
   ,'0'                                                              -- 自证声明标志
   ,t1.tax_org_cate_cd                                               -- 税收机构类别代码
   ,' '                                                              -- 税收居民国家代码
   ,t1.tax_resdnt_idti_cd                                            -- 税收居民身份代码
   ,''                                                               -- 基本账户开户行名称
	 ,''                                                             -- 基本账户账号
   ,''                                                               -- 纳税人识别号
   ,''                                                               -- 纳税人识别号空值原因描述
   ,'0'                                                              -- 属于两高行业标志
   ,'0'                                                              -- 办理税务登记证标志
   ,'0'                                                              -- 国家重点企业标志
   ,'0'                                                              -- 集团客户标志二
   ,''                                                               -- 集团客户编号
   ,t1.group_cust_type_cd                                            -- 集团类型代码
   ,t1.parent_corp_cust_id                                           -- 集团母公司编号
   ,'-'                                                              -- 限制或鼓励行业代码
   ,'0'                                                              -- 有董事会标志
   ,'0'                                                              -- 绿色信贷客户标志
   ,'-'                                                              -- 绿色信贷分类_旧版代码
   ,'-'                                                              -- 绿色信贷分类_新版代码
   ,'-'                                                              -- 科技型企业分类代码
   ,''                                                               -- 科技型企业认定日期
   ,''																 -- 文教健康标志
   ,''																 -- 普惠标志
   ,''                                                               -- 三农标志
   ,''                                                               -- 有无进出口经营权标志 modify by xn20210621
   ,'0'                                                              -- 逃废债企业标志
   ,'0'                                                              -- 有无进出口经营项标志
   ,'1'                                                              -- 居民标志
   ,t40.attr_val as dom_overs_flg                                    -- 境内外标志
   ,''                                                               -- 绿色债券项目标志
   ,t1.dom_work_addr                                                 -- 办公地址
   ,''                                                               -- 办公地址邮政编码
   ,t1.dom_work_addr                                                 -- 通讯地址
   ,''                                                               -- 通讯地址邮政编码
   ,nvl(trim(t3.phys_addr),trim(t3.cont_addr))       	             -- 生产经营地址
   ,t3.zip_cd					                                     -- 生产经营地址邮政编码
   ,''                                                               -- 经营所在地行政区划代码
   ,''                                                               -- 信贷客户风险评级代码
   ,''                                	                             -- 信贷客户风险评级开始日期
   ,''                                                               -- 信贷客户风险评级到期日期
   ,'99'                                                             -- 所有制类型代码
   ,''                                                               -- 存款类客户标志
   ,''                                                               -- 信贷客户标志代码
   ,''                                                               -- 担保客户标志代码
   ,''                    											 -- 企业关停标志
   ,'0'                                                              -- 政府融资平台标志
   ,'0'                       	                                     -- 空头支票黑名单标志
   ,to_date('29991231','yyyymmdd')									 -- 首贷日期
   ,'X' as orgnz_surviv_status_cd	                                 -- 组织机构存续状态代码
   ,'' as corp_idti_idf_type_cd	                                     -- 企业身份标识类型代码
   ,'0' as major_contrior_cnt	                                     -- 主要出资人个数
   ,'0' as actl_ctrler_cnt	                                         -- 实际控制人个数
   ,'' as fin_dept_phone	                                         -- 财务部门联系电话
   ,t1.job_cd                                                        -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
from ${iml_schema}.pty_group_party t1
left join ${iml_schema}.pty_cust t2
  on t1.party_id = t2.party_id
 and t2.sorc_sys_cd = 'EIFS'
 and t2.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t2.job_cd = 'eifsf1'
 and t2.id_mark <> 'D'
left join ${iml_schema}.pty_party_phys_addr_h t3
  on t1.party_id = t3.party_id
 and t3.phys_addr_type_cd = '21'   --生产经营地址
 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t3.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_attr_h t40
  on t1.party_id = t40.party_id
 and t40.attr_name='B0002'
 and t40.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t40.end_dt > to_date('${batch_date}', 'yyyymmdd')
 and t40.job_cd = 'eifsf1'
left join ${iol_schema}.eifs_t00_party_pub_info t47
  on t1.party_id = t47.cust_num
 and t47.start_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t47.end_dt > to_date('${batch_date}', 'yyyymmdd')
where t1.create_dt <= to_date('${batch_date}', 'yyyymmdd')
 and t1.id_mark <> 'D'
 and t1.job_cd='eifsf1';
commit;

--3.1 create tmp table
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_corp_cust_basic_info_01
nologging
compress ${option_switch} for query high
as select p3.customerid as customerid,
          nvl(trim(p3.mfcustomerid), p3.customerid) as cust_num,
          p2.groupid as belong_group_id,
          p3.customername as belong_group_name,
          t1.corpid as belong_group_orgnz_cd,
          t1.loancardno as belong_group_loan_card_no,
          case
           when t1.countrycode = 'OTH' then
            'XXX'
           else
            nvl(trim(t1.countrycode), 'XXX') end as country_cd,
          nvl(trim(t1.registerregioncode), '000000') as belong_group_rgst_cty_rg_cd,
          t1.registeradd as belong_group_rgst_addr,
          --t1.parentcompanyofficeadd as belong_group_dom_work_addr,
          p2.membertype as mem_type_cd
     from ${iol_schema}.icms_ent_info t1
    inner join ${iol_schema}.icms_group_member_relative p2
       on p2.membercustomerid = t1.customerid
      and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
      and p2.membertype in ('1', '2')
	    and p2.groupcustomertype = '5'  --集团客户
    inner join ${iol_schema}.icms_customer_info p3
       on p2.membercustomerid = p3.customerid
      and p3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and p3.end_dt > to_date('${batch_date}', 'yyyymmdd')
    where 1=1
	  --and p2.id_mark <>'D'
	    and t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
      and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

--第三组（共四组）对公信贷对公客户信息
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_basic_info_ex02(
   etl_dt                                -- 数据日期
   ,lp_id                                -- 法人编号
   ,cust_id                              -- 客户编号
   ,cust_name                            -- 客户名称
   ,cust_en_name                         -- 客户英文名称
   ,cust_kind_cd						             -- 客户种类代码
   ,open_acct_dt                         -- 开户日期
   ,belong_org_id                        -- 所属机构编号
   ,open_acct_org_id                     -- 开户机构编号
   ,anti_mon_lau_belong_org_id           -- 反洗钱归属机构编号
   ,open_acct_teller_id                  -- 开户柜员编号
   ,open_acct_chn_cd                     -- 开户渠道代码
   ,create_chn_cd                        -- 创建渠道代码
   ,cust_mgr_id                          -- 客户经理编号
   ,cust_type_cd                         -- 客户类型代码
   ,crdt_cust_type_cd					           -- 信贷客户类型代码
   ,cust_lev_cd                          -- 客户级别代码
   ,depositr_cate_cd					           -- 存款人类别代码
   ,bal_pay_way_cd                       -- 收支方式代码
   ,cust_status_cd                       -- 客户状态代码
   ,corp_anl_inco                        -- 企业年收入
   ,corp_year_bus_lmt                    -- 企业年营业额
   ,corp_found_dt                        -- 企业成立日期
   ,corp_size_cd                         -- 企业规模代码
   ,indus_categy_cd                      -- 行业门类代码
   ,indus_type_cd                        -- 行业类型代码
   ,indus_type_cd_crdtc                  -- 行业类型代码_征信
   ,phone_crdtc                          -- 联系电话_征信
   ,corp_type_cd                         -- 企业类型代码
   ,cty_rg_cd                            -- 国家和行政区划代码
   ,rg_cd                                -- 行政区划代码
   ,econ_char_cd                         -- 经济性质代码
   ,econ_type_cd                         -- 经济类型代码
   ,orgnz_cd                             -- 组织机构代码
   ,orgnz_type_cd                        -- 组织机构类型代码
   ,natnal_econ_dept_type_cd             -- 国民经济部门类型代码
   ,indus_level5_cls_cd                  -- 行业五级分类代码
   ,indus_crdt_rating_cd                 -- 行业信用评级代码
   ,soci_crdt_cd                         -- 社会信用代码
   ,bus_lics_num                         -- 营业执照号
   ,bus_lics_exp_dt                      -- 营业执照到期日期
   ,nation_tax_rgst_cert_num             -- 国税登记证号码
   ,local_tax_rgst_cert_num              -- 地税登记证号码
   ,fin_lics_num						 -- 金融许可证号
   ,pbc_pay_bank_no						 -- 人行支付行号
   ,econ_orgnz_form_cd                   -- 经济组织形式代码
   ,loan_card_no                         -- 贷款卡号
   ,stock_cd                             -- 股票代码
   ,oper_range                           -- 经营范围
   ,emply_qtty                           -- 企业员工人数
   ,curr_cd                              -- 币种代码
   ,rgst_cap                             -- 注册资金
   ,rgst_addr                            -- 注册地址
   ,rgst_dt                              -- 注册日期
   ,rgstion_cd                           -- 登记注册代码
   ,mang_field_prop_cd                   -- 经营场地所有权代码
   ,corp_rgstion_type                    -- 企业登记注册类型
   ,paid_in_capital                      -- 实收资本
   ,paid_in_capital_curr_cd              -- 实收资本币种
   ,invtor_cty_cd                        -- 投资方国家代码
   ,mang_field_area                      -- 经营场地面积
   ,asset_tot                            -- 资产总额
   ,net_asset_tot                        -- 净资产总额
   ,single_lp_flg                        -- 独立法人标志
   ,high_new_tech_corp_flg               -- 高新技术企业标志
   ,rela_party_flg                       -- 关联方标志
   ,rela_group_type_cd                   -- 关联集团类型代码
   ,lp_org_name                          -- 法人机构名称
   ,lp_org_type_cd                       -- 法人机构类型代码
   ,lp_org_cust_id                       -- 法人机构客户编号
   ,group_cust_flg                       -- 集团客户标志
   ,cbrc_sb_flg                          -- 银监小企业标志
   ,labor_inte_flg						 -- 劳动密集型标志
   ,hold_type_cd                         -- 控股类型代码
   ,off_shore_cust_flg                   -- 离岸客户标志
   ,prit_etp_flg                         -- 民营企业标志
   ,ctysd_corp_flg                       -- 农村企业标志
   ,corp_grow_stage_cd					 -- 企业成长阶段代码
   ,list_corp_type_cd                    -- 上市公司类型代码
   ,strate_new_indus_cls_cd              -- 战略性新兴产业分类代码
   ,list_corp_flg                        -- 上市公司标志
   ,strtg_cust_flg                       -- 战略客户标志
   ,open_cap                             -- 开办资金
   ,crdt_cust_flg                        -- 授信客户标志
   ,stament_flg                          -- 自证声明标志
   ,tax_org_cate_cd                      -- 税收机构类别代码
   ,tax_resdnt_cty_cd                    -- 税收居民国家代码
   ,tax_resdnt_idti_cd                   -- 税收居民身份代码
   ,basic_acct_open_bank_name            -- 基本账户开户行名称
	 ,basic_acct_acct_num                -- 基本账户账号
   ,tax_num								 -- 纳税人识别号
   ,tax_num_null_rs_descb				 -- 纳税人识别号空值原因描述
   ,bel_thi_flg                          -- 属于两高行业标志
   ,trast_tax_regi_cert_flg              -- 办理税务登记证标志
   ,cty_key_enterp_flg                   -- 国家重点企业标志
   ,group_corp_flg                       -- 集团客户标志二
   ,group_cust_id                        -- 集团客户编号
   ,group_type_cd                        -- 集团类型代码
   ,group_parent_corp_id                 -- 集团母公司编号
   ,lmt_or_encrge_indus_cd               -- 限制或鼓励行业代码
   ,have_bod_flg                         -- 有董事会标志
   ,green_crdt_cust_flg                  -- 绿色信贷客户标志
   ,green_crdt_cls_cd                    -- 绿色信贷分类_旧版代码
   ,green_crdt_cls_new                   -- 绿色信贷分类_新版代码
   ,sci_tech_corp_cls_cd                 -- 科技型企业分类代码
   ,sci_tech_corp_idtfy_dt               -- 科技型企业认定日期
   ,edu_hea_flg							 -- 文教健康标志
   ,inc_flg								 -- 普惠标志
   ,araf_flg                             -- 三农标志
   ,is_mx_mgmt_righ_flg                  -- 有无进出口经营权标志
   ,escp_debt_corp_flg                   -- 逃废债企业标志
   ,is_mx_oper_item_flg                  -- 有无进出口经营项标志
   ,resdnt_flg       					 -- 居民标志
   ,dom_overs_flg                        -- 境内外标志
   ,green_bond_proj_flg                  -- 绿色债券项目标志
   ,work_addr        					 -- 办公地址
   ,work_addr_zip_cd 					 -- 办公地址邮政编码
   ,posta_addr       					 -- 通讯地址
   ,posta_addr_zip_cd					 -- 通讯地址邮政编码
   ,prod_mang_addr       				 -- 生产经营地址
   ,prod_mang_addr_zip_cd				 -- 生产经营地址邮政编码
   ,mang_site_cd                         -- 经营所在地行政区划代码
   ,crdt_cust_risk_rating_cd      		 -- 信贷客户风险评级代码
   ,crdt_cust_risk_rating_start_dt		 -- 信贷客户风险评级开始日期
   ,crdt_cust_risk_rating_exp_dt  		 -- 信贷客户风险评级到期日期
   ,ownsp_type_cd                 		 -- 所有制类型代码
   ,dep_class_cust_flg                   -- 存款类客户标志
   ,loan_class_cust_flg                  -- 信贷客户标志代码
   ,guar_class_cust_flg                  -- 担保客户标志代码
   ,corp_close_flg                		 -- 企业关停标志
   ,gover_fin_plat_flg                   -- 政府融资平台标志
   ,short_check_blklist_flg              -- 空头支票黑名单标志
   ,fir_lon_dt							 -- 首贷日期
   ,orgnz_surviv_status_cd	             -- 组织机构存续状态代码
   ,corp_idti_idf_type_cd	             -- 企业身份标识类型代码
   ,major_contrior_cnt	                 -- 主要出资人个数
   ,actl_ctrler_cnt	                     -- 实际控制人个数
   ,fin_dept_phone	                     -- 财务部门联系电话
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select to_date('${batch_date}','yyyymmdd')                        -- 数据日期
       ,'9999'                                                    -- 法人编号
       ,t14.customerid                                            -- 客户编号
       ,t4.corp_name                                              -- 客户名称
       ,t5.party_name                                             -- 客户英文名称
       ,'PUBLIC_TYPE'                                             -- 客户种类代码
       ,t1.inputdate                                              -- 开户日期
       ,t11.belongorgid                                           -- 所属机构编号
       ,''                                                        -- 开户机构编号
	     ,''                                                      -- 反洗钱归属机构编号
       ,t1.inputuserid                                            -- 开户柜员编号
       ,'100001'                                                  -- 开户渠道代码
       ,''                                                        -- 创建渠道代码
       ,t11.belonguserid                                          -- 客户经理编号
       ,t4.corp_cust_type_cd                                      -- 客户类型代码
       ,t14.customertype                                          -- 信贷客户类型代码
       ,''                                                        -- 客户级别代码
       ,'299'                                                     -- 存款人类别代码
       ,''                                                        -- 收支方式代码
       ,''                                                        -- 客户状态代码
       ,null                                                      -- 企业年收入
       ,t1.salesamount	                                          -- 企业年营业额
       ,t4.corp_found_dt                                          -- 企业成立日期
       ,t4.corp_size_cd                                           -- 企业规模代码
       ,''                                                        -- 行业门类代码
       ,t4.indus_type_cd                                          -- 行业类型代码
       ,''                                                        -- 行业类型代码_征信
       ,''                                                        -- 联系电话_征信
       ,t4.org_type_cd                                            -- 企业类型代码
       ,nvl(trim(t1.countrycode),'XXX')                           -- 国家和行政区划代码
       ,nvl(trim(t1.registerregioncode),'000000')                 -- 行政区划代码
       /*,decode(t1.orgtype, '100', '999','110', '001','120', '002',
		    			'130', '005','140', '999','150', '006','160', '005',
		    			'170', '003','200', '004','300', '999','400', '007','999') -- 经济性质代码*/
       ,t1.orgtype                                                -- 经济性质代码
       ,replace(t4.econ_type_cd,'-','')                           -- 经济类型代码
       ,t16.cert_num                                              -- 组织机构代码
       ,nvl(trim(t4.orgnz_type_cd),'00')                          -- 组织机构类型代码
       ,'000'                                                     -- 国民经济部门类型代码
       ,''                                                        -- 行业五级分类代码
       ,'-'                                                       -- 行业信用评级代码
       ,t17.cert_num                                              -- 统一社会信用代码
       ,t18.cert_num                                              -- 营业执照号
       ,case when t1.licensematurity = to_date('00010101','yyyymmdd')
             then to_date('29991231','yyyymmdd') else  t1.licensematurity end -- 营业执照到期日期
       ,t4.nation_tax_tax_regi_cert_num                           -- 国税登记证号码
       ,t4.local_tax_tax_regi_cert_num                            -- 地税登记证号码
       ,t4.fin_inst_lics                                          -- 金融许可证号
       ,t4.ibank_no                                               -- 人行支付行号
       ,''                                                        -- 经济组织形式代码
       ,t1.loancardno                                             -- 贷款卡号
       ,''                                                        -- 股票代码
       ,t4.oper_range                                             -- 经营范围
       ,t4.emply_qtty                                             -- 企业员工人数
       ,t1.registercurrency                                       -- 币种代码
       ,t1.registeramount                                         -- 注册资金
       ,t1.registeradd                                            -- 注册地址
       ,t1.registerdate                                           -- 注册日期
       ,''                                                        -- 登记注册代码
       ,decode(t4.econ_type_cd, '1', '1', '2', '2', '9')          -- 经营场地所有权代码
       ,''                                                        -- 企业登记注册类型
       ,t1.paidamount                                             -- 实收资本
       ,t1.paidcurrency                                           -- 实收资本币种
       ,nvl(trim(t1.countrycode),'XXX')                           -- 投资方国家代码
       ,t4.oper_field_area                                        -- 经营场地面积
       ,t6.tot_asset                                              -- 资产总额
       ,null                                                      -- 净资产总额
       ,decode(t4.single_lp_flg, '1', '1', '0')                   -- 独立法人标志
       ,null                                                      -- 高新技术企业标志
       ,t4.rela_party_flg                                         -- 关联方标志
       ,nvl(trim(t4.rela_group_type_cd),'-')                      -- 关联集团类型代码
       ,''                                                        -- 法人机构名称
       ,'-'                                                       -- 法人机构类型代码
       ,''                                                        -- 法人机构客户编号
       ,(case when trim(t12.customerid) is not null then '1' else null end) as group_cust_flg  -- 集团客户标志
       ,decode(t4.cbrc_sb_flg, '1', '1', '0', '0','')             -- 银监小企业标志
       ,t4.labor_inte_corp_flg                                    -- 劳动密集型标志
       ,t4.hold_type_cd                                           -- 控股类型代码
       ,decode(t4.off_shore_cust_flg, '1', '1', '0')              -- 离岸客户标志
       ,decode(t4.prit_etp_flg, '1', '1', '0')                    -- 民营企业标志
       ,decode(t4.ctysd_corp_flg, '1', '1', '0')                  -- 农村企业标志
       ,t4.corp_grow_stage_cd                                     -- 企业成长阶段代码
       ,t4.list_corp_type_cd                                      -- 上市公司类型代码
       ,'0'                                                       -- 战略性新兴产业分类代码
       ,decode(t4.list_corp_flg, '1', '1')                        -- 上市公司标志
       ,''                                                        -- 战略客户标志
       ,0                                                         -- 开办资金
       ,case when trim(t9.customerid) is not null then '1' else '0' end  -- 授信客户标志
       ,''                                                         -- 自证声明标志
       ,''                                                         -- 税收机构类别代码
       ,''                                                         -- 税收居民国家代码
       ,''                                                         -- 税收居民身份代码
       ,''                                                         -- 基本账户开户行名称
       ,''                                                         -- 基本账户账号
       ,''                                                         -- 纳税人识别号
       ,''                                                         -- 纳税人识别号空值原因描述
       ,decode(t4.bel_thi_flg, '1', '1')                           -- 属于两高行业标志
       ,''                                                         -- 办理税务登记证标志
       ,''                                                         -- 国家重点企业标志
       ,(case when trim(t12.customerid) is not null then '1' else null end) as group_corp_flg  -- 集团客户标志二
       ,t12.belong_group_id                                        -- 集团客户编号
       ,''                                                         -- 集团类型代码
       ,case when t12.mem_type_cd = '1' then t12.cust_num
             else '' end  	                                       -- 集团母公司编号
       ,t4.ins_adj_type_cd                                         -- 限制或鼓励行业代码
       ,''                                                         -- 有董事会标志
       ,decode(t20.itemname, '是', '1', '否','0','-')              -- 绿色信贷客户标志
       ,t21.tagvalue                                               -- 绿色信贷分类_旧版代码
       ,t22.tagvalue                                               -- 绿色信贷分类_新版代码
       ,'-'                                                        -- 科技型企业分类代码
       ,''                                                         -- 科技型企业认定日期
       ,''                                                         -- 文教健康标志
       ,''                                                         -- 普惠标志
       ,''                                                         -- 三农标志
       ,decode(t4.is_mx_mgmt_righ_flg, '1', '1', '0')              -- 有无进出口经营权标志
       ,decode(t4.escp_debt_corp_flg, '1', '1', '0')               -- 逃废债企业标志
       ,decode(t4.is_mx_oper_item_flg, '1', '1', '0')              -- 有无进出口经营项标志
       ,''                                                         -- 居民标志
       ,''                                                         -- 境内外标志
       ,t1.isfreshzqproj                                           -- 绿色债券项目标志
       ,t3.cont_addr                                               -- 办公地址
       ,t3.zip_cd                                                  -- 办公地址邮政编码
       ,t3.cont_addr                                               -- 通讯地址
       ,t3.zip_cd                                                  -- 通讯地址邮政编码
       ,''                                                         -- 生产经营地址
       ,''                                                         -- 生产经营地址邮政编码
       ,''                                                         -- 经营所在地行政区划代码
       ,''                                                         -- 信贷客户风险评级代码
       ,''                                                         -- 信贷客户风险评级开始日期
       ,''                                                         -- 信贷客户风险评级到期日期
       ,'99'                                                       -- 所有制类型代码
	     ,''                                                         -- 存款类客户标志
       ,''                                                         -- 信贷客户标志代码
       ,''                                                         -- 担保客户标志代码
       ,(case when t8.party_id is not null then '1' else '0' end)  -- 企业关停标志
       ,(case when t15.certid is not null then '1' else '0' end)   -- 政府融资平台标志
       ,t10.bad_check_black                                        -- 空头支票黑名单标志
       ,t4.fir_lon_dt                                              -- 首贷日期
       ,t4.org_status_cd                                           -- 组织机构存续状态代码
       ,t4.crdtc_subm_corp_idti_idf_type_cd                        -- 企业身份标识类型代码
       ,t4.major_contrior_cnt                                      -- 主要出资人个数
       ,t4.actl_ctrler_cnt                                         -- 实际控制人个数
       ,t4.fin_dept_phone                                          -- 财务部门联系电话
       ,'icmsf1'                                                   -- 任务代码
       ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- etl处理时间戳
  from ${iol_schema}.icms_ent_info t1
 inner join (select ci.*, row_number() over(partition by customerid order by migtflag desc) rn
               from ${iol_schema}.icms_customer_info ci
              where ci.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and ci.end_dt > to_date('${batch_date}', 'yyyymmdd')
             ) t14
    on t1.customerid = t14.customerid
   and t14.rn = 1
	 and t14.customerid not in ('2015090700000114',
                               '2014060300000006',
                               '2013041000000004',
                               '2013120300000025',
                               '2013061300000012',
                               '2013022800000015',
                               '2014061000000019',
                               '2014101700000011',
                               '#OwnerID',
                               '2015081300000033')
	left join (select h.party_id,
                    h.lp_id,
                    h.belong_group_id,
                    h.data_src_cd,
                    row_number() over(partition by party_id, lp_id order by data_src_cd desc) rn
               from ${iml_schema}.pty_corp_cust_group_info_h h
              where h.start_dt <= to_date('${batch_date}','yyyymmdd')
                and h.end_dt > to_date('${batch_date}','yyyymmdd')
                and h.job_cd ='icmsf1') t2
	  on t1.customerid = t2.party_id
   and t2.rn = 1
  left join ${iml_schema}.pty_party_phys_addr_h t3
    on t1.customerid = t3.party_id
   and t3.phys_addr_type_cd = '06'
	 and t3.start_dt <= to_date('${batch_date}', 'yyyymmdd')
	 and t3.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t3.job_cd='icmsf1'
	 and t3.seq_num = 1
  left join ${iml_schema}.pty_corp_cust t4
    on t1.customerid = t4.cust_id
 	 and t4.create_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t4.id_mark <> 'D'
 	 and t4.job_cd='icmsf1'
  left join ${iml_schema}.pty_party_name_h t5
    on t1.customerid = t5.party_id
   and t5.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t5.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t5.party_name_type_cd = '06'  --英文名
	 and t5.job_cd='icmsf1'
  left join ${iml_schema}.pty_corp_oper_situ_h t6
    on t1.customerid = t6.party_id
   and t6.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t6.end_dt > to_date('${batch_date}', 'yyyymmdd')
	 and t6.job_cd='icmsf1'
  left join (select ad.party_id,
                    ai.warn_name,
                    ad.warn_hibchy,
                    ad.rgst_dt,
                    row_number() over(partition by ad.party_id order by ad.rgst_dt desc) rn
               from ${iml_schema}.pty_cust_risk_warn_info_h ad,
                    ${iml_schema}.ref_risk_warn_sgn_dtl_h ai
              where ad.obj_type_name = 'ALERTAPPLY'
                and ad.warn_id = ai.warn_id
                and ad.warn_status_cd = '1'
                and ai.warn_name like 'A03%'
				        and ad.job_cd = 'icmsf1'
				        and ai.job_cd = 'icmsf1'
                and ad.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and ad.end_dt > to_date('${batch_date}', 'yyyymmdd')
                and ai.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and ai.end_dt > to_date('${batch_date}', 'yyyymmdd')
				  ) t8
    on t1.customerid = t8.party_id
   and t8.rn = 1
  left join (select distinct customerid
               from (select cust_id as customerid
                       from ${iml_schema}.agt_loan_appl_basic_info_h
                      where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                        and end_dt > to_date('${batch_date}', 'yyyymmdd')
                      union
                     select cust_id as customerid
                       from ${iml_schema}.agt_loan_cont_info_h
                      where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                        and end_dt > to_date('${batch_date}', 'yyyymmdd'))) t9  --授信客户编号
    on t1.customerid = t9.customerid
  left join (select cust_no as cust_id,
                    bad_check_black,
                    glob_seq_num,
                    task_id,
                    row_number() over(partition by cust_no order by task_id desc) rn
               from ${iol_schema}.scps_bp_corporate_tb t
              where trim(cust_no) is not null
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')) t10
    on t10.cust_id = nvl(trim(t14.mfcustomerid), t14.customerid)
	 and t10.rn = 1
  left join (select cb.*,
                    row_number() over(partition by cb.customerid order by inputdate desc) rn
               from ${iol_schema}.icms_customer_belong cb
              where manageright = '1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
	              and end_dt > to_date('${batch_date}', 'yyyymmdd')
               ) t11
    on t1.customerid = t11.customerid
   and t11.rn = 1
  left join ${icl_schema}.tmp_cmm_corp_cust_basic_info_01 t12
    on t1.customerid = t12.customerid
  left join (select distinct certtype, certid
               from ${iol_schema}.icms_customer_special
              where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and end_dt > to_date('${batch_date}', 'yyyymmdd')
                and specialcustomertype = '03' --融资平台客户名单
			  ) t15
    on t14.certtype = t15.certtype
   and t14.certid = t15.certid
  left join ${iml_schema}.pty_party_cert_info_h t16
    on t1.customerid = t16.party_id
   and t16.cert_type_cd = '2020' --组织机构代码证
   and t16.cert_status_cd='1'
   and t16.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t16.end_dt > to_date('${batch_date}','yyyymmdd')
   and t16.job_cd ='icmsf1'
  left join ${iml_schema}.pty_party_cert_info_h t17
    on t1.customerid = t17.party_id
   and t17.cert_type_cd = '2313' --组织机构代码证
   and t17.cert_status_cd='1'
   and t17.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t17.end_dt > to_date('${batch_date}','yyyymmdd')
   and t17.job_cd ='icmsf1'
  left join ${iml_schema}.pty_party_cert_info_h t18
    on t1.customerid = t18.party_id
   and t18.cert_type_cd = '2010' --组织机构代码证
   and t18.cert_status_cd='1'
   and t18.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t18.end_dt > to_date('${batch_date}','yyyymmdd')
   and t18.job_cd ='icmsf1'
  left join ${iol_schema}.icms_tag_term_final_data t19 
    on t1.customerid = t19.objectno 
   and t19.taghirearchy = '10'
   and t19.tagid= '2024111800000002'	
   and t19.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t19.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_code_config t20
    on t20.tagid = t19.tagid
   and t20.itemno = t19.tagvalue 
   and t20.etl_dt = to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_term_final_data t21
    on t1.customerid = t21.objectno
   and t21.taghirearchy = '10'
   and t21.tagid= '2025041410000004'
   and t21.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t21.end_dt > to_date('${batch_date}','yyyymmdd')
  left join ${iol_schema}.icms_tag_term_final_data t22
    on t1.customerid = t22.objectno
   and t22.taghirearchy = '10'
   and t22.tagid= '2025041410000005'
   and t22.start_dt <= to_date('${batch_date}','yyyymmdd')
   and t22.end_dt > to_date('${batch_date}','yyyymmdd')   
 where t1.start_dt <= to_date('${batch_date}','yyyymmdd')
 	 and t1.end_dt > to_date('${batch_date}','yyyymmdd')
 ;

commit;
--第四组（共四组）对公信贷集团客户和客户群
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_basic_info_ex02(
   etl_dt                                -- 数据日期
   ,lp_id                                -- 法人编号
   ,cust_id                              -- 客户编号
   ,cust_name                            -- 客户名称
   ,cust_en_name                         -- 客户英文名称
   ,cust_kind_cd						 -- 客户种类代码
   ,open_acct_dt                         -- 开户日期
   ,belong_org_id                        -- 所属机构编号
   ,open_acct_org_id                     -- 开户机构编号
   ,anti_mon_lau_belong_org_id           -- 反洗钱归属机构编号
   ,open_acct_teller_id                  -- 开户柜员编号
   ,open_acct_chn_cd                     -- 开户渠道代码
   ,create_chn_cd                        -- 创建渠道代码
   ,cust_mgr_id                          -- 客户经理编号
   ,cust_type_cd                         -- 客户类型代码
   ,crdt_cust_type_cd					 -- 信贷客户类型代码
   ,cust_lev_cd                          -- 客户级别代码
   ,depositr_cate_cd					 -- 存款人类别代码
   ,bal_pay_way_cd                       -- 收支方式代码
   ,cust_status_cd                       -- 客户状态代码
   ,corp_anl_inco                        -- 企业年收入
   ,corp_year_bus_lmt                    -- 企业年营业额
   ,corp_found_dt                        -- 企业成立日期
   ,corp_size_cd                         -- 企业规模代码
   ,indus_categy_cd                      -- 行业门类代码
   ,indus_type_cd                        -- 行业类型代码
   ,indus_type_cd_crdtc                  -- 行业类型代码_征信
   ,phone_crdtc                          -- 联系电话_征信
   ,corp_type_cd                         -- 企业类型代码
   ,cty_rg_cd                            -- 国家和SINGLE_LP_FLG
   ,rg_cd                                -- 行政区划代码
   ,econ_char_cd                         -- 经济性质代码
   ,econ_type_cd                         -- 经济类型代码
   ,orgnz_cd                             -- 组织机构代码
   ,orgnz_type_cd                        -- 组织机构类型代码
   ,natnal_econ_dept_type_cd             -- 国民经济部门类型代码
   ,indus_level5_cls_cd                  -- 行业五级分类代码
   ,indus_crdt_rating_cd                 -- 行业信用评级代码
   ,soci_crdt_cd                         -- 社会信用代码    （机构信用代码）
   ,bus_lics_num                         -- 营业执照号      （统一社会信用代码）
   ,bus_lics_exp_dt                      -- 营业执照到期日期
   ,nation_tax_rgst_cert_num             -- 国税登记证号码  （税务登记证）
   ,local_tax_rgst_cert_num              -- 地税登记证号码
   ,fin_lics_num						 -- 金融许可证号
   ,pbc_pay_bank_no						 -- 人行支付行号
   ,econ_orgnz_form_cd                   -- 经济组织形式代码
   ,loan_card_no                         -- 贷款卡号
   ,stock_cd                             -- 股票代码
   ,oper_range                           -- 经营范围
   ,emply_qtty                           -- 企业员工人数
   ,curr_cd                              -- 币种代码
   ,rgst_cap                             -- 注册资金
   ,rgst_addr                            -- 注册地址
   ,rgst_dt                              -- 注册日期
   ,rgstion_cd                           -- 登记注册代码
   ,mang_field_prop_cd                   -- 经营场地所有权代码
   ,corp_rgstion_type                    -- 企业登记注册类型
   ,paid_in_capital                      -- 实收资本
   ,paid_in_capital_curr_cd              -- 实收资本币种
   ,invtor_cty_cd                        -- 投资方国家代码
   ,mang_field_area                      -- 经营场地面积
   ,asset_tot                            -- 资产总额
   ,net_asset_tot                        -- 净资产总额
   ,single_lp_flg                        -- 独立法人标志
   ,high_new_tech_corp_flg               -- 高新技术企业标志
   ,rela_party_flg                       -- 关联方标志
   ,rela_group_type_cd                   -- 关联集团类型代码
   ,lp_org_name                          -- 法人机构名称
   ,lp_org_type_cd                       -- 法人机构类型代码
   ,lp_org_cust_id                       -- 法人机构客户编号
   ,group_cust_flg                       -- 集团客户标志
   ,cbrc_sb_flg                          -- 银监小企业标志
   ,labor_inte_flg				    	 -- 劳动密集型标志
   ,hold_type_cd                         -- 控股类型代码
   ,off_shore_cust_flg                   -- 离岸客户标志
   ,prit_etp_flg                         -- 民营企业标志
   ,ctysd_corp_flg                       -- 农村企业标志
   ,corp_grow_stage_cd					 -- 企业成长阶段代码
   ,list_corp_type_cd                    -- 上市公司类型代码
   ,strate_new_indus_cls_cd              -- 战略性新兴产业分类代码
   ,list_corp_flg                        -- 上市公司标志
   ,strtg_cust_flg                       -- 战略客户标志
   ,open_cap                             -- 开办资金
   ,crdt_cust_flg                        -- 授信客户标志
   ,stament_flg                          -- 自证声明标志
   ,tax_org_cate_cd                      -- 税收机构类别代码
   ,tax_resdnt_cty_cd                    -- 税收居民国家代码
   ,tax_resdnt_idti_cd                   -- 税收居民身份代码
   ,basic_acct_open_bank_name            -- 基本账户开户行名称
	 ,basic_acct_acct_num                -- 基本账户账号
   ,tax_num								 -- 纳税人识别号
   ,tax_num_null_rs_descb				 -- 纳税人识别号空值原因描述
   ,bel_thi_flg                          -- 属于两高行业标志
   ,trast_tax_regi_cert_flg              -- 办理税务登记证标志
   ,cty_key_enterp_flg                   -- 国家重点企业标志
   ,group_corp_flg                       -- 集团客户标志二
   ,group_cust_id                        -- 集团客户编号
   ,group_type_cd                        -- 集团类型代码
   ,group_parent_corp_id                 -- 集团母公司编号
   ,lmt_or_encrge_indus_cd               -- 限制或鼓励行业代码
   ,have_bod_flg                         -- 有董事会标志
   ,green_crdt_cust_flg                  -- 绿色信贷客户标志
   ,green_crdt_cls_cd                    -- 绿色信贷分类_旧版代码
   ,green_crdt_cls_new                   -- 绿色信贷分类_新版代码
   ,sci_tech_corp_cls_cd                 -- 科技型企业分类代码
   ,sci_tech_corp_idtfy_dt               -- 科技型企业认定日期
   ,edu_hea_flg                          -- 文教健康标志
   ,inc_flg								 -- 普惠标志
   ,araf_flg                             -- 三农标志
   ,is_mx_mgmt_righ_flg                  -- 有无进出口经营权标志
   ,escp_debt_corp_flg                   -- 逃废债企业标志
   ,is_mx_oper_item_flg                  -- 有无进出口经营项标志
   ,resdnt_flg       					 -- 居民标志
   ,dom_overs_flg                        -- 境内外标志
   ,green_bond_proj_flg                  -- 绿色债券项目标志
   ,work_addr        					 -- 办公地址
   ,work_addr_zip_cd 					 -- 办公地址邮政编码
   ,posta_addr       					 -- 通讯地址
   ,posta_addr_zip_cd					 -- 通讯地址邮政编码
   ,prod_mang_addr       				 -- 生产经营地址
   ,prod_mang_addr_zip_cd				 -- 生产经营地址邮政编码
   ,mang_site_cd                         -- 经营所在地行政区划代码
   ,crdt_cust_risk_rating_cd      		 -- 信贷客户风险评级代码
   ,crdt_cust_risk_rating_start_dt		 -- 信贷客户风险评级开始日期
   ,crdt_cust_risk_rating_exp_dt  		 -- 信贷客户风险评级到期日期
   ,ownsp_type_cd                 		 -- 所有制类型代码
   ,dep_class_cust_flg                   -- 存款类客户标志
   ,loan_class_cust_flg                  -- 信贷客户标志代码
   ,guar_class_cust_flg                  -- 担保客户标志代码
   ,corp_close_flg                		 -- 企业关停标志
   ,gover_fin_plat_flg                   -- 政府融资平台标志
   ,short_check_blklist_flg              -- 空头支票黑名单标志
   ,fir_lon_dt							 -- 首贷日期
   ,orgnz_surviv_status_cd	             -- 组织机构存续状态代码
   ,corp_idti_idf_type_cd	             -- 企业身份标识类型代码
   ,major_contrior_cnt	                 -- 主要出资人个数
   ,actl_ctrler_cnt	                     -- 实际控制人个数
   ,fin_dept_phone	                     -- 财务部门联系电话
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select
   to_date('${batch_date}','yyyymmdd')                          -- 数据日期
   ,'9999'                                                      -- 法人编号
   ,nvl(trim(t2.mfcustomerid), t2.customerid)                   -- 客户编号
   ,t1.groupname                                                -- 客户名称
   ,t1.groupabbname                                             -- 客户英文名称
   ,'PUBLIC_TYPE'                                               -- 客户种类代码
   ,t1.inputdate                                                -- 开户日期
   ,t3.belongorgid                                              -- 所属机构编号
   ,''                                                          -- 开户机构编号
   ,''                                                          -- 反洗钱归属机构编号
   ,t1.inputuserid                                              -- 开户柜员编号
   ,'100001'                                                    -- 开户渠道代码
   ,''                                                          -- 创建渠道代码
   ,t3.belonguserid                                             -- 客户经理编号
   ,case when t2.customertype in ('5','6') then '2'
        else  nvl(trim(t2.customertype),'-') end                -- 客户类型代码
   ,t2.customertype                                             -- 信贷客户类型代码  --1个人客户 2公司客户 3同业客户 4内部客户 5集团客户 6客户群
   ,''                                                          -- 客户级别代码
   ,'299'                                                       -- 存款人类别代码
   ,''                                                          -- 收支方式代码
   ,''                                                          -- 客户状态代码
   ,null                                                        -- 企业年收入
   ,0                                                           -- 企业年营业额
   ,null                                                        -- 企业成立日期
   ,'0'                                                         -- 企业规模代码
   ,''                                                          -- 行业门类代码
   ,t1.industrytype                                             -- 行业类型代码
   ,''                                                          -- 行业类型代码_征信
   ,''                                                          -- 联系电话_征信
   ,case when t1.groupcredittype = '01' then '02'
        when t1.groupcredittype = '02' then '08'
      else '0' end                                              -- 企业类型代码
   ,nvl(trim(t1.countrycode),'XXX')                             -- 国家和行政区划代码
   ,t1.registerregioncode                                       -- 行政区划代码
   ,'000'                                                       -- 经济性质代码
   ,'9999'                                                      -- 经济类型代码
   ,''                                                          -- 组织机构代码
   ,''                                                          -- 组织机构类型代码
   ,'000'                                                       -- 国民经济部门类型代码
   ,''                                                          -- 行业五级分类代码
   ,'-'                                                         -- 行业信用评级代码
   ,''                                                          -- 统一社会信用代码
   ,''                                                          -- 营业执照号
   ,to_date('29991231','yyyymmdd')                              -- 营业执照到期日期
   ,''                                                          -- 国税登记证号码
   ,''                                                          -- 地税登记证号码
   ,''                                                          -- 金融许可证号
   ,''                                                          -- 人行支付行号
   ,''                                                          -- 经济组织形式代码
   ,''                                                          -- 贷款卡号
   ,''                                                          -- 股票代码
   ,t1.businessscope                                            -- 经营范围
   ,0                                                           -- 企业员工人数
   ,'CNY'                                                       -- 币种代码
   ,''                                                          -- 注册资金
   ,''                                                          -- 注册地址
   ,null                                                        -- 注册日期
   ,''                                                          -- 登记注册代码
   ,''                                                          -- 经营场地所有权代码
   ,''                                                          -- 企业登记注册类型
   ,0                                                           -- 实收资本
   ,''                                                          -- 实收资本币种
   ,''                                                          -- 投资方国家代码
   ,0                                                           -- 经营场地面积
   ,0                                                           -- 资产总额
   ,null                                                        -- 净资产总额
   ,''                                                          -- 独立法人标志
   ,null                                                        -- 高新技术企业标志
   ,t1.isrelatedparty                                           -- 关联方标志
   ,t1.grouptype                                                -- 关联集团类型代码
   ,''                                                          -- 法人机构名称
   ,'-'                                                         -- 法人机构类型代码
   ,''                                                          -- 法人机构客户编号
   ,'0'                                                         -- 集团客户标志  /*1-个人客户 2-公司客户 3-同业客户 4-内部客户 5-集团客户 6-客户群*/
   ,'0'                                                         -- 银监小企业标志
   ,''                                                          -- 劳动密集型标志
   ,''                                                          -- 控股类型代码
   ,''                                                          -- 离岸客户标志
   ,''                                                          -- 民营企业标志
   ,''                                                          -- 农村企业标志
   ,''                                                          -- 企业成长阶段代码
   ,'-'                                                         -- 上市公司类型代码
   ,'0'                                                         -- 战略性新兴产业分类代码
   ,''                                                          -- 上市公司标志
   ,''                                                          -- 战略客户标志
   ,0                                                           -- 开办资金
   ,case when t4.cust_id is not null then '1' else '0' end      -- 授信客户标志
   ,''                                                          -- 自证声明标志
   ,''                                                          -- 税收机构类别代码
   ,''                                                          -- 税收居民国家代码
   ,''                                                          -- 税收居民身份代码
   ,''                                                          -- 基本账户开户行名称
   ,''                                                          -- 基本账户账号
   ,''                                                          -- 纳税人识别号
   ,''                                                          -- 纳税人识别号空值原因描述
   ,''                                                          -- 属于两高行业标志
   ,''                                                          -- 办理税务登记证标志
   ,''                                                          -- 国家重点企业标志
   ,'0'                                                         -- 集团客户标志二
   ,''                                                          -- 集团客户编号
   ,''                                                          -- 集团类型代码
   ,t1.keymembercustomerid                                      -- 集团母公司编号
   ,''                                                          -- 限制或鼓励行业代码
   ,''                                                          -- 有董事会标志
   ,'0'                                                         -- 绿色信贷客户标志
   ,'-'                                                         -- 绿色信贷分类_旧版代码
   ,'-'                                                         -- 绿色信贷分类_新版代码
   ,'-'                                                         -- 科技型企业分类代码
   ,''                                                          -- 科技型企业认定日期
   ,''                                                          -- 文教健康标志
   ,''                                                          -- 普惠标志
   ,''                                                          -- 三农标志
   ,''                                                          -- 有无进出口经营权标志
   ,''                                                          -- 逃废债企业标志
   ,''                                                          -- 有无进出口经营项标志
   ,''                                                          -- 居民标志
   ,''                                                          -- 境内外标志
   ,''                                                          -- 绿色债券项目标志
   ,t7.cont_addr                                                -- 办公地址
   ,t7.zip_cd                                                   -- 办公地址邮政编码
   ,t7.cont_addr                                                -- 通讯地址
   ,t7.zip_cd                                                   -- 通讯地址邮政编码
   ,''                                                          -- 生产经营地址
   ,''                                                          -- 生产经营地址邮政编码
   ,'000000'                                                    -- 经营所在地行政区划代码
   ,''                                                          -- 信贷客户风险评级代码
   ,''                                                          -- 信贷客户风险评级开始日期
   ,''                                                          -- 信贷客户风险评级到期日期
   ,'99'                                                        -- 所有制类型代码
   ,''                                                          -- 存款类客户标志
   ,''                                                          -- 信贷客户标志代码
   ,''                                                          -- 担保客户标志代码
   ,(case when t8.cust_id is not null then '1' else '0' end)    -- 企业关停标志
   ,(case when t9.certid is not null then '1' else '0' end)     -- 政府融资平台标志
   ,t10.bad_check_black                                         -- 空头支票黑名单标志
   ,t1.firstloandate                                            -- 首贷日期
   ,t1.groupstatus                                              -- 组织机构存续状态代码
   ,t1.corpidetitytype                                          -- 企业身份标识类型代码
   ,t1.investmencounts                                          -- 主要出资人个数
   ,t1.actualcontrollercounts                                   -- 实际控制人个数
   ,''                                                          -- 财务部门联系电话
   ,'icmsf1'                                                    -- 任务代码
   ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') -- etl处理时间戳
from ${iol_schema}.icms_group_info t1
  inner join ${iol_schema}.icms_customer_info t2
     on t1.groupid = t2.customerid
    and t2.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t2.end_dt > to_date('${batch_date}', 'yyyymmdd')
  left join (select cb.*,
                    row_number() over(partition by cb.customerid order by inputdate desc) rn
               from ${iol_schema}.icms_customer_belong cb
              where manageright = '1'
                and start_dt <= to_date('${batch_date}', 'yyyymmdd')
	              and end_dt > to_date('${batch_date}', 'yyyymmdd')
               ) t3
    on t1.groupid = t3.customerid
   and t3.rn = 1
  left join (select distinct cust_id
              from (select cust_id
                       from ${iml_schema}.agt_loan_appl_basic_info_h
                      where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                        and end_dt > to_date('${batch_date}', 'yyyymmdd')
  				              and job_cd = 'icmsf1'
                      union
                     select cust_id
                       from ${iml_schema}.agt_loan_cont_info_h
                      where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                        and end_dt > to_date('${batch_date}', 'yyyymmdd')
  				   and job_cd = 'icmsf1')
  				   ) t4
    on t1.groupid = t4.cust_id
  left join ${iml_schema}.pty_party_phys_addr_h t7
    on t1.groupid = t7.party_id
   and t7.phys_addr_type_cd='06'
   and t7.start_dt <= to_date('${batch_date}', 'yyyymmdd')
   and t7.end_dt > to_date('${batch_date}', 'yyyymmdd')
   and t7.job_cd = 'icmsf1'
  left join (select ad.cust_id,
                    ai.warn_name,
                    ad.warn_hibchy,
                    ad.rgst_dt,
                    row_number() over(partition by ad.cust_id order by ad.rgst_dt desc) rn
               from ${iml_schema}.pty_cust_risk_warn_info_h ad,
                    ${iml_schema}.ref_risk_warn_sgn_dtl_h ai
              where ad.obj_type_name = 'AlertApply'
                and ad.warn_id = ai.warn_id
                and ad.warn_status_cd = '1'
                and ai.warn_name like 'A03%'
                and ad.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and ad.end_dt > to_date('${batch_date}', 'yyyymmdd')
  			        and ad.job_cd = 'icmsf1'
                and ai.start_dt <= to_date('${batch_date}', 'yyyymmdd')
                and ai.end_dt > to_date('${batch_date}', 'yyyymmdd')
  			        and ai.job_cd = 'icmsf1'
  			  ) t8
     on t1.groupid = t8.cust_id
   left join (select distinct certtype, certid
                from ${iol_schema}.icms_customer_special
               where start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and end_dt > to_date('${batch_date}', 'yyyymmdd')
                 and specialcustomertype = '03'  --融资平台客户名单
  			   ) t9
    on t2.certtype = t9.certtype
   and t2.certid = t9.certid
   left join (select cust_no as cust_id,
                     bad_check_black,
                     glob_seq_num,
                     task_id,
                     row_number() over(partition by cust_no order by task_id desc) rn
                from ${iol_schema}.scps_bp_corporate_tb t
               where trim(cust_no) is not null
                 and start_dt <= to_date('${batch_date}', 'yyyymmdd')
                 and end_dt > to_date('${batch_date}', 'yyyymmdd')) t10
     on t10.cust_id = nvl(trim(t2.mfcustomerid), t2.customerid)
  where t1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
    and t1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_basic_info_ex(
   etl_dt                                -- 数据日期
   ,lp_id                                -- 法人编号
   ,cust_id                              -- 客户编号
   ,cust_name                            -- 客户名称
   ,cust_en_name                         -- 客户英文名称
   ,cust_kind_cd						 -- 客户种类代码
   ,open_acct_dt                         -- 开户日期
   ,belong_org_id                        -- 所属机构编号
   ,open_acct_org_id                     -- 开户机构编号
   ,anti_mon_lau_belong_org_id           -- 反洗钱归属机构编号
   ,open_acct_teller_id                  -- 开户柜员编号
   ,open_acct_chn_cd                     -- 开户渠道代码
   ,create_chn_cd                        -- 创建渠道代码
   ,cust_mgr_id                          -- 客户经理编号
   ,cust_type_cd                         -- 客户类型代码
   ,crdt_cust_type_cd					 -- 信贷客户类型代码
   ,cust_lev_cd                          -- 客户级别代码
   ,depositr_cate_cd					 -- 存款人类别代码
   ,bal_pay_way_cd                       -- 收支方式代码
   ,cust_status_cd                       -- 客户状态代码
   ,corp_anl_inco                        -- 企业年收入
   ,corp_year_bus_lmt                    -- 企业年营业额
   ,corp_found_dt                        -- 企业成立日期
   ,corp_size_cd                         -- 企业规模代码
   ,indus_categy_cd                      -- 行业门类代码
   ,indus_type_cd                        -- 行业类型代码
   ,indus_type_cd_crdtc                  -- 行业类型代码_征信
   ,phone_crdtc                          -- 联系电话_征信
   ,corp_type_cd                         -- 企业类型代码
   ,cty_rg_cd                            -- 国家和行政区划代码
   ,rg_cd                                -- 行政区划代码
   ,econ_char_cd                         -- 经济性质代码
   ,econ_type_cd                         -- 经济类型代码
   ,orgnz_cd                             -- 组织机构代码
   ,orgnz_type_cd                        -- 组织机构类型代码
   ,natnal_econ_dept_type_cd             -- 国民经济部门类型代码
   ,indus_level5_cls_cd                  -- 行业五级分类代码
   ,indus_crdt_rating_cd                 -- 行业信用评级代码
   ,soci_crdt_cd                         -- 社会信用代码
   ,bus_lics_num                         -- 营业执照号
   ,bus_lics_exp_dt                      -- 营业执照到期日期
   ,nation_tax_rgst_cert_num             -- 国税登记证号码
   ,local_tax_rgst_cert_num              -- 地税登记证号码
   ,fin_lics_num						 -- 金融许可证号
   ,pbc_pay_bank_no						 -- 人行支付行号
   ,econ_orgnz_form_cd                   -- 经济组织形式代码
   ,loan_card_no                         -- 贷款卡号
   ,stock_cd                             -- 股票代码
   ,oper_range                           -- 经营范围
   ,emply_qtty                           -- 企业员工人数
   ,curr_cd                              -- 币种代码
   ,rgst_cap                             -- 注册资金
   ,rgst_addr                            -- 注册地址
   ,rgst_dt                              -- 注册日期
   ,rgstion_cd                           -- 登记注册代码
   ,mang_field_prop_cd                   -- 经营场地所有权代码
   ,corp_rgstion_type                    -- 企业登记注册类型
   ,paid_in_capital                      -- 实收资本
   ,paid_in_capital_curr_cd              -- 实收资本币种
   ,invtor_cty_cd                        -- 投资方国家代码
   ,mang_field_area                      -- 经营场地面积
   ,asset_tot                            -- 资产总额
   ,net_asset_tot                        -- 净资产总额
   ,single_lp_flg                        -- 独立法人标志
   ,high_new_tech_corp_flg               -- 高新技术企业标志
   ,rela_party_flg                       -- 关联方标志
   ,rela_group_type_cd                   -- 关联集团类型代码
   ,lp_org_name                          -- 法人机构名称
   ,lp_org_type_cd                       -- 法人机构类型代码
   ,lp_org_cust_id                       -- 法人机构客户编号
   ,group_cust_flg                       -- 集团客户标志
   ,cbrc_sb_flg                          -- 银监小企业标志
   ,labor_inte_flg						 -- 劳动密集型标志
   ,hold_type_cd                         -- 控股类型代码
   ,off_shore_cust_flg                   -- 离岸客户标志
   ,prit_etp_flg                         -- 民营企业标志
   ,ctysd_corp_flg                       -- 农村企业标志
   ,corp_grow_stage_cd					 -- 企业成长阶段代码
   ,list_corp_type_cd                    -- 上市公司类型代码
   ,strate_new_indus_cls_cd              -- 战略性新兴产业分类代码
   ,list_corp_flg                        -- 上市公司标志
   ,strtg_cust_flg                       -- 战略客户标志
   ,open_cap                             -- 开办资金
   ,crdt_cust_flg                        -- 授信客户标志
   ,stament_flg                          -- 自证声明标志
   ,tax_org_cate_cd                      -- 税收机构类别代码
   ,tax_resdnt_cty_cd                    -- 税收居民国家代码
   ,tax_resdnt_idti_cd                   -- 税收居民身份代码
   ,basic_acct_open_bank_name            -- 基本账户开户行名称
	 ,basic_acct_acct_num                -- 基本账户账号
   ,tax_num								 -- 纳税人识别号
   ,tax_num_null_rs_descb				 -- 纳税人识别号空值原因描述
   ,bel_thi_flg                          -- 属于两高行业标志
   ,trast_tax_regi_cert_flg              -- 办理税务登记证标志
   ,cty_key_enterp_flg                   -- 国家重点企业标志
   ,group_corp_flg                       -- 集团客户标志二
   ,group_cust_id                        -- 集团客户编号
   ,group_type_cd                        -- 集团类型代码
   ,group_parent_corp_id                 -- 集团母公司编号
   ,lmt_or_encrge_indus_cd               -- 限制或鼓励行业代码
   ,have_bod_flg                         -- 有董事会标志
   ,green_crdt_cust_flg                  -- 绿色信贷客户标志
   ,green_crdt_cls_cd                    -- 绿色信贷分类_旧版代码
   ,green_crdt_cls_new                   -- 绿色信贷分类_新版代码
   ,sci_tech_corp_cls_cd                 -- 科技型企业分类代码
   ,sci_tech_corp_idtfy_dt               -- 科技型企业认定日期
   ,edu_hea_flg							 -- 文教健康标志
   ,inc_flg                              -- 普惠标志
   ,araf_flg                             -- 三农标志
   ,is_mx_mgmt_righ_flg                  -- 有无进出口经营权标志
   ,escp_debt_corp_flg                   -- 逃废债企业标志
   ,is_mx_oper_item_flg                  -- 有无进出口经营项标志
   ,resdnt_flg       					 -- 居民标志
   ,dom_overs_flg                        -- 境内外标志
   ,green_bond_proj_flg                  -- 绿色债券项目标志
   ,work_addr        					 -- 办公地址
   ,work_addr_zip_cd 					 -- 办公地址邮政编码
   ,posta_addr       					 -- 通讯地址
   ,posta_addr_zip_cd					 -- 通讯地址邮政编码
   ,prod_mang_addr       				 -- 生产经营地址
   ,prod_mang_addr_zip_cd				 -- 生产经营地址邮政编码
   ,mang_site_cd                         -- 经营所在地行政区划代码
   ,crdt_cust_risk_rating_cd      		 -- 信贷客户风险评级代码
   ,crdt_cust_risk_rating_start_dt		 -- 信贷客户风险评级开始日期
   ,crdt_cust_risk_rating_exp_dt  		 -- 信贷客户风险评级到期日期
   ,ownsp_type_cd                 		 -- 所有制类型代码
   ,dep_class_cust_flg                   -- 存款类客户标志
   ,loan_class_cust_flg                  -- 信贷客户标志代码
   ,guar_class_cust_flg                  -- 担保客户标志代码
   ,corp_close_flg                		 -- 企业关停标志
   ,gover_fin_plat_flg                   -- 政府融资平台标志
   ,short_check_blklist_flg              -- 空头支票黑名单标志
   ,fir_lon_dt							 -- 首贷日期
   ,orgnz_surviv_status_cd	             -- 组织机构存续状态代码
   ,corp_idti_idf_type_cd	             -- 企业身份标识类型代码
   ,major_contrior_cnt	                 -- 主要出资人个数
   ,actl_ctrler_cnt	                     -- 实际控制人个数
   ,fin_dept_phone	                     -- 财务部门联系电话
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select
   t1.etl_dt                                                                              -- 数据日期
   ,t1.lp_id                                                                              -- 法人编号
   ,nvl(trim(t2.cust_id),t1.cust_id)                                                      -- 客户编号
   ,t1.cust_name                                                                          -- 客户名称
   ,t1.cust_en_name                                                                       -- 客户英文名称
   ,nvl(trim(t2.cust_kind_cd),t1.cust_kind_cd)                                            -- 客户种类代码
   ,t1.open_acct_dt                                                                       -- 开户日期
   ,nvl(trim(t2.belong_org_id),t1.belong_org_id)                                          -- 所属机构编号
   ,t1.open_acct_org_id                                                                   -- 开户机构编号
   ,t1.anti_mon_lau_belong_org_id                                                         -- 反洗钱归属机构编号
   ,nvl(trim(t2.open_acct_teller_id),t1.open_acct_teller_id)                              -- 开户柜员编号
   ,nvl(t1.open_acct_chn_cd,'100001')                                                     -- 开户渠道代码
   ,t1.create_chn_cd                                                                      -- 创建渠道代码
   ,t1.cust_mgr_id                                                                        -- 客户经理编号
   ,coalesce(nvl(trim(t2.cust_type_cd),t1.cust_type_cd),'-')                              -- 客户类型代码
   ,t2.crdt_cust_type_cd                                                                  -- 信贷客户类型代码
   ,t1.cust_lev_cd                                                                        -- 客户级别代码
   ,nvl(t1.depositr_cate_cd,'299')                                                        -- 存款人类别代码
   ,'-'                                                                                   -- 收支方式代码
   ,nvl(t1.cust_status_cd,'-')                                                            -- 客户状态代码
   ,t1.corp_anl_inco                                                                      -- 企业年收入    modify by xn20210518 nvl(trim(t2.corp_anl_inco),t1.corp_anl_inco)
   ,nvl(trim(t2.corp_year_bus_lmt),t1.corp_year_bus_lmt)                                  -- 企业年营业额
   ,t1.corp_found_dt                                                                      -- 企业成立日期
   ,t1.corp_size_cd                                                                       -- 企业规模代码
   ,t1.indus_categy_cd                                                                    -- 行业门类代码
   ,case when t2.crdt_cust_type_cd in ('5','6') 
         then t2.indus_type_cd else nvl(t1.indus_type_cd,'-') end                         -- 行业类型代码
   ,nvl(t1.indus_type_cd_crdtc,'-')                                                       -- 行业类型代码_征信
   ,t1.phone_crdtc                                                                        -- 联系电话_征信
   ,t1.corp_type_cd                                                                       -- 企业类型代码
   ,nvl(t1.cty_rg_cd,'XXX')                                                               -- 国家和行政区划代码
   ,nvl(t1.rg_cd,'000000')                                                                -- 行政区划代码
   ,coalesce(trim(replace(t2.econ_char_cd,'999','')),trim(t1.econ_char_cd),'999')         -- 经济性质代码
   ,decode(t1.econ_type_cd,'-','9999',t1.econ_type_cd)                                    -- 经济类型代码
   ,nvl(trim(t2.orgnz_cd),t1.orgnz_cd)                                                    -- 组织机构代码
   ,nvl(decode(trim(t2.orgnz_type_cd),'00','',trim(t2.orgnz_type_cd)),t1.orgnz_type_cd)   -- 组织机构类型代码
   ,nvl(t1.natnal_econ_dept_type_cd,'000')                                                -- 国民经济部门类型代码
   ,t1.indus_level5_cls_cd                                                                -- 行业五级分类代码
   ,t1.indus_crdt_rating_cd                                                               -- 行业信用评级代码
   ,nvl(trim(t2.soci_crdt_cd),t1.soci_crdt_cd)                                            -- 社会信用代码
   ,t1.bus_lics_num                                                                       -- 营业执照号
   ,t1.bus_lics_exp_dt                                                                    -- 营业执照到期日期
   ,t1.nation_tax_rgst_cert_num                                                           -- 国税登记证号码
   ,t1.local_tax_rgst_cert_num                                                            -- 地税登记证号码
   ,t1.fin_lics_num                                                                       -- 金融许可证号
   ,t1.pbc_pay_bank_no									                                                  -- 人行支付行号
   ,nvl(t1.econ_orgnz_form_cd,'Z9999') 			                                              -- 经济组织形式代码
   ,t1.loan_card_no                                                                       -- 贷款卡号
   ,t1.stock_cd                                                                           -- 股票代码
   ,t1.oper_range                                                                         -- 经营范围
   ,t1.emply_qtty                                                                         -- 企业员工人数nvl(trim(t2.emply_qtty),t1.emply_qtty)
   ,coalesce(trim(t2.curr_cd),trim(t1.curr_cd),'-')                                       -- 币种代码
   ,t1.rgst_cap                                                                           -- 注册资金
   ,t1.rgst_addr                                                                          -- 注册地址
   ,t1.rgst_dt                                                                            -- 注册日期
   ,t1.rgstion_cd                                                                         -- 登记注册代码
   ,t1.mang_field_prop_cd                	                                 						    -- 经营场地所有权代码
   ,nvl(t1.corp_rgstion_type,'000')                                                       -- 企业登记注册类型
   ,t1.paid_in_capital                                                                    -- 实收资本nvl(trim(t2.paid_in_capital),t1.paid_in_capital)
   ,coalesce(trim(t2.paid_in_capital_curr_cd),trim(t1.paid_in_capital_curr_cd),'-')       -- 实收资本币种
   ,nvl(t1.invtor_cty_cd,'XXX')                                                           -- 投资方国家代码
   ,t1.mang_field_area                                                                    -- 经营场地面积nvl(trim(t2.mang_field_area),t1.mang_field_area)
   ,t1.asset_tot                                                                          -- 资产总额nvl(trim(t2.asset_tot),t1.asset_tot)
   ,t1.net_asset_tot                                                                      -- 净资产总额nvl(trim(t2.net_asset_tot),t1.net_asset_tot)
   ,nvl(trim(t1.single_lp_flg),'0')                                                       -- 独立法人标志
   ,nvl(trim(t1.high_new_tech_corp_flg),'0')                                              -- 高新技术企业标志
   ,nvl(trim(t1.rela_party_flg),'0')                                                      -- 关联方标志
   ,t2.rela_group_type_cd                                                                 -- 关联集团类型代码
   ,t1.lp_org_name                                                                        -- 法人机构名称
   ,t1.lp_org_type_cd                                                                     -- 法人机构类型代码
   ,t1.lp_org_cust_id                                                                     -- 法人机构客户编号
   ,coalesce(trim(t2.group_cust_flg),t1.group_cust_flg, '0')                              -- 集团客户标志
   ,nvl(t1.cbrc_sb_flg,'0')                                                               -- 银监小企业标志
   ,t1.labor_inte_flg																				                              -- 劳动密集型标志
   ,nvl(t1.hold_type_cd,'Z9999')                                                          -- 控股类型代码
   ,t1.off_shore_cust_flg                                                                 -- 离岸客户标志
   ,nvl(trim(t1.prit_etp_flg),'0')                                                        -- 民营企业标志
   ,decode(trim(t1.ctysd_corp_flg),'-','0',t1.ctysd_corp_flg)                             -- 农村企业标志
   ,t1.corp_grow_stage_cd 											                                          -- 企业成长阶段代码
   ,t1.list_corp_type_cd                                                                  -- 上市公司类型代码
   ,nvl(t1.strate_new_indus_cls_cd,'0')                                                   -- 战略性新兴产业分类代码
   ,t1.list_corp_flg                                                                      -- 上市公司标志
   ,t1.strtg_cust_flg                                                                     -- 战略客户标志
   ,nvl(t1.open_cap,'0')                       															              -- 开办资金
   ,coalesce(t2.crdt_cust_flg,t1.crdt_cust_flg,'-')                                       -- 授信客户标志
   ,decode(trim(t1.stament_flg),'-','0',t1.stament_flg)                                   -- 自证声明标志
   ,t1.tax_org_cate_cd                                                                    -- 税收机构类别代码
   ,t1.tax_resdnt_cty_cd                                                                  -- 税收居民国家代码
   ,t1.tax_resdnt_idti_cd                                                                 -- 税收居民身份代码
   ,t1.basic_acct_open_bank_name                                                          -- 基本账户开户行名称
	 ,nvl(trim(t1.basic_acct_acct_num),t1.basic_acct_acct_num)                              -- 基本账户账号
   ,t1.tax_num                                                                            -- 纳税人识别号
   ,t1.tax_num_null_rs_descb                                                              -- 纳税人识别号空值原因描述
   ,decode(trim(t1.bel_thi_flg),'-','0',t1.bel_thi_flg)                                   -- 属于两高行业标志
   ,decode(t1.trast_tax_regi_cert_flg,'-','0',t1.trast_tax_regi_cert_flg)                 -- 办理税务登记证标志
   ,decode(t1.cty_key_enterp_flg,'-','0',t1.cty_key_enterp_flg)                           -- 国家重点企业标志
   ,coalesce(trim(t2.group_corp_flg),nvl(t1.group_corp_flg, '0'), '0')                    -- 集团客户标志二
   ,t1.group_cust_id                                                                      -- 集团客户编号
   ,t1.group_type_cd                                                                      -- 集团类型代码
   ,t1.group_parent_corp_id                                                               -- 集团母公司编号
   ,t1.lmt_or_encrge_indus_cd                                                             -- 限制或鼓励行业代码
   ,t2.have_bod_flg                                                                       -- 有董事会标志
   ,t2.green_crdt_cust_flg                                                                -- 绿色信贷客户标志
   ,nvl(trim(t2.green_crdt_cls_cd),'-')                                                   -- 绿色信贷分类_旧版代码
   ,nvl(trim(t2.green_crdt_cls_new),'-')                                                  -- 绿色信贷分类_新版代码
   ,nvl(t1.sci_tech_corp_cls_cd,'-')                                                      -- 科技型企业分类代码
   ,t1.sci_tech_corp_idtfy_dt                                                             -- 科技型企业认定日期
   ,''																					  -- 文教健康标志
   ,''																					  -- 普惠标志
   ,''                                                                                    -- 三农标志
   ,t1.is_mx_mgmt_righ_flg                                                                -- 有无进出口经营权标志
   ,t1.escp_debt_corp_flg                                                                 -- 逃废债企业标志
   ,t1.is_mx_oper_item_flg                                                                -- 有无进出口经营项标志
   ,t1.resdnt_flg                                                                         -- 居民标志
   ,t1.dom_overs_flg                                                                      -- 境内外标志
   ,t2.green_bond_proj_flg                                                                -- 绿色债券项目标志
   ,t1.work_addr                                                                          -- 办公地址
   ,t1.work_addr_zip_cd                                                                   -- 办公地址邮政编码
   ,t1.posta_addr                                                                         -- 通讯地址
   ,t1.posta_addr_zip_cd                                                                  -- 通讯地址邮政编码
   ,t1.prod_mang_addr                                                                     -- 生产经营地址
   ,t1.prod_mang_addr_zip_cd                                                              -- 生产经营地址邮政编码
   ,nvl(trim(t1.mang_site_cd),'000000')                                                   -- 经营所在地行政区划代码
   ,''                                                                                    -- 信贷客户风险评级代码
   ,''                                                                                    -- 信贷客户风险评级开始日期
   ,''                                                                                    -- 信贷客户风险评级到期日期
   ,nvl(trim(t2.ownsp_type_cd),'99')                                                      -- 所有制类型代码
   ,t1.dep_class_cust_flg                                                                 -- 存款类客户标志
   ,t1.loan_class_cust_flg                                                                -- 信贷客户标志代码
   ,t1.guar_class_cust_flg                                                                -- 担保客户标志代码
   ,nvl(trim(t2.corp_close_flg),t1.corp_close_flg)                                        -- 企业关停标志
   ,nvl(trim(t2.gover_fin_plat_flg),'0')                                                  -- 政府融资平台标志
   ,nvl(trim(t2.short_check_blklist_flg),t1.short_check_blklist_flg)                      -- 空头支票黑名单标志
   ,nvl(trim(t2.fir_lon_dt),to_date('29991231','yyyymmdd'))                               -- 首贷日期
   ,nvl(trim(t2.orgnz_surviv_status_cd),t1.orgnz_surviv_status_cd)                        -- 组织机构存续状态代码
   ,t1.corp_idti_idf_type_cd                                                              -- 企业身份标识类型代码
   ,nvl(trim(t2.major_contrior_cnt),'0')                                                  -- 主要出资人个数
   ,nvl(trim(t2.actl_ctrler_cnt),'0')                                                     -- 实际控制人个数
   ,t2.fin_dept_phone                                                                     -- 财务部门联系电话
   ,t1.job_cd                                                                             -- 任务代码
   ,t1.etl_timestamp                                                                      -- etl处理时间戳
 from ${icl_schema}.cmm_corp_cust_basic_info_ex01 t1
 left join ${icl_schema}.cmm_corp_cust_basic_info_ex02 t2
 	 on t1.cust_id = t2.cust_id
 where 1 = 1 ;
commit;

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_corp_cust_basic_info_ex(
   etl_dt                                -- 数据日期
   ,lp_id                                -- 法人编号
   ,cust_id                              -- 客户编号
   ,cust_name                            -- 客户名称
   ,cust_en_name                         -- 客户英文名称
   ,cust_kind_cd						 -- 客户种类代码
   ,open_acct_dt                         -- 开户日期
   ,belong_org_id                        -- 所属机构编号
   ,open_acct_org_id                     -- 开户机构编号
   ,anti_mon_lau_belong_org_id           -- 反洗钱归属机构编号
   ,open_acct_teller_id                  -- 开户柜员编号
   ,open_acct_chn_cd                     -- 开户渠道代码
   ,create_chn_cd                        -- 创建渠道代码
   ,cust_mgr_id                          -- 客户经理编号
   ,cust_type_cd                         -- 客户类型代码
   ,crdt_cust_type_cd					 -- 信贷客户类型代码
   ,cust_lev_cd                          -- 客户级别代码
   ,depositr_cate_cd					 -- 存款人类别代码
   ,bal_pay_way_cd                       -- 收支方式代码
   ,cust_status_cd                       -- 客户状态代码
   ,corp_anl_inco                        -- 企业年收入
   ,corp_year_bus_lmt                    -- 企业年营业额
   ,corp_found_dt                        -- 企业成立日期
   ,corp_size_cd                         -- 企业规模代码
   ,indus_categy_cd                      -- 行业门类代码
   ,indus_type_cd                        -- 行业类型代码
   ,indus_type_cd_crdtc                  -- 行业类型代码_征信
   ,phone_crdtc                          -- 联系电话_征信
   ,corp_type_cd                         -- 企业类型代码
   ,cty_rg_cd                            -- 国家和行政区划代码
   ,rg_cd                                -- 行政区划代码
   ,econ_char_cd                         -- 经济性质代码
   ,econ_type_cd                         -- 经济类型代码
   ,orgnz_cd                             -- 组织机构代码
   ,orgnz_type_cd                        -- 组织机构类型代码
   ,natnal_econ_dept_type_cd             -- 国民经济部门类型代码
   ,indus_level5_cls_cd                  -- 行业五级分类代码
   ,indus_crdt_rating_cd                 -- 行业信用评级代码
   ,soci_crdt_cd                         -- 社会信用代码
   ,bus_lics_num                         -- 营业执照号
   ,bus_lics_exp_dt                      -- 营业执照到期日期
   ,nation_tax_rgst_cert_num             -- 国税登记证号码
   ,local_tax_rgst_cert_num              -- 地税登记证号码
   ,fin_lics_num						 -- 金融许可证号
   ,pbc_pay_bank_no						 -- 人行支付行号
   ,econ_orgnz_form_cd                   -- 经济组织形式代码
   ,loan_card_no                         -- 贷款卡号
   ,stock_cd                             -- 股票代码
   ,oper_range                           -- 经营范围
   ,emply_qtty                           -- 企业员工人数
   ,curr_cd                              -- 币种代码
   ,rgst_cap                             -- 注册资金
   ,rgst_addr                            -- 注册地址
   ,rgst_dt                              -- 注册日期
   ,rgstion_cd                           -- 登记注册代码
   ,mang_field_prop_cd                   -- 经营场地所有权代码
   ,corp_rgstion_type                    -- 企业登记注册类型
   ,paid_in_capital                      -- 实收资本
   ,paid_in_capital_curr_cd              -- 实收资本币种
   ,invtor_cty_cd                        -- 投资方国家代码
   ,mang_field_area                      -- 经营场地面积
   ,asset_tot                            -- 资产总额
   ,net_asset_tot                        -- 净资产总额
   ,single_lp_flg                        -- 独立法人标志
   ,high_new_tech_corp_flg               -- 高新技术企业标志
   ,rela_party_flg                       -- 关联方标志
   ,rela_group_type_cd                   -- 关联集团类型代码
   ,lp_org_name                          -- 法人机构名称
   ,lp_org_type_cd                       -- 法人机构类型代码
   ,lp_org_cust_id                       -- 法人机构客户编号
   ,group_cust_flg                       -- 集团客户标志
   ,cbrc_sb_flg                          -- 银监小企业标志
   ,labor_inte_flg						 -- 劳动密集型标志
   ,hold_type_cd                         -- 控股类型代码
   ,off_shore_cust_flg                   -- 离岸客户标志
   ,prit_etp_flg                         -- 民营企业标志
   ,ctysd_corp_flg                       -- 农村企业标志
   ,corp_grow_stage_cd					 -- 企业成长阶段代码
   ,list_corp_type_cd                    -- 上市公司类型代码
   ,strate_new_indus_cls_cd              -- 战略性新兴产业分类代码
   ,list_corp_flg                        -- 上市公司标志
   ,strtg_cust_flg                       -- 战略客户标志
   ,open_cap                             -- 开办资金
   ,crdt_cust_flg                        -- 授信客户标志
   ,stament_flg                          -- 自证声明标志
   ,tax_org_cate_cd                      -- 税收机构类别代码
   ,tax_resdnt_cty_cd                    -- 税收居民国家代码
   ,tax_resdnt_idti_cd                   -- 税收居民身份代码
   ,basic_acct_open_bank_name            -- 基本账户开户行名称
	 ,basic_acct_acct_num                -- 基本账户账号
   ,tax_num								 -- 纳税人识别号
   ,tax_num_null_rs_descb				 -- 纳税人识别号空值原因描述
   ,bel_thi_flg                          -- 属于两高行业标志
   ,trast_tax_regi_cert_flg              -- 办理税务登记证标志
   ,cty_key_enterp_flg                   -- 国家重点企业标志
   ,group_corp_flg                       -- 集团客户标志二
   ,group_cust_id                        -- 集团客户编号
   ,group_type_cd                        -- 集团类型代码
   ,group_parent_corp_id                 -- 集团母公司编号
   ,lmt_or_encrge_indus_cd               -- 限制或鼓励行业代码
   ,have_bod_flg                         -- 有董事会标志
   ,green_crdt_cust_flg                  -- 绿色信贷客户标志
   ,green_crdt_cls_cd                    -- 绿色信贷分类_旧版代码
   ,green_crdt_cls_new                   -- 绿色信贷分类_新版代码
   ,sci_tech_corp_cls_cd                 -- 科技型企业分类代码
   ,sci_tech_corp_idtfy_dt               -- 科技型企业认定日期
   ,edu_hea_flg							 -- 文教健康标志
   ,inc_flg                              -- 普惠标志
   ,araf_flg                             -- 三农标志
   ,is_mx_mgmt_righ_flg                  -- 有无进出口经营权标志
   ,escp_debt_corp_flg                   -- 逃废债企业标志
   ,is_mx_oper_item_flg                  -- 有无进出口经营项标志
   ,resdnt_flg       					 -- 居民标志
   ,dom_overs_flg                        -- 境内外标志
   ,green_bond_proj_flg                  -- 绿色债券项目标志
   ,work_addr        					 -- 办公地址
   ,work_addr_zip_cd 					 -- 办公地址邮政编码
   ,posta_addr       					 -- 通讯地址
   ,posta_addr_zip_cd					 -- 通讯地址邮政编码
   ,prod_mang_addr       				 -- 生产经营地址
   ,prod_mang_addr_zip_cd				 -- 生产经营地址邮政编码
   ,mang_site_cd                         -- 经营所在地行政区划代码
   ,crdt_cust_risk_rating_cd      		 -- 信贷客户风险评级代码
   ,crdt_cust_risk_rating_start_dt		 -- 信贷客户风险评级开始日期
   ,crdt_cust_risk_rating_exp_dt  		 -- 信贷客户风险评级到期日期
   ,ownsp_type_cd                 		 -- 所有制类型代码
   ,dep_class_cust_flg                   -- 存款类客户标志
   ,loan_class_cust_flg                  -- 信贷客户标志代码
   ,guar_class_cust_flg                  -- 担保客户标志代码
   ,corp_close_flg                		 -- 企业关停标志
   ,gover_fin_plat_flg                   -- 政府融资平台标志
   ,short_check_blklist_flg              -- 空头支票黑名单标志
   ,fir_lon_dt							 -- 首贷日期
   ,orgnz_surviv_status_cd	             -- 组织机构存续状态代码
   ,corp_idti_idf_type_cd	             -- 企业身份标识类型代码
   ,major_contrior_cnt	                 -- 主要出资人个数
   ,actl_ctrler_cnt	                     -- 实际控制人个数
   ,fin_dept_phone	                     -- 财务部门联系电话
   ,job_cd                               -- 任务代码
   ,etl_timestamp                        -- etl处理时间戳
)
select
   t1.etl_dt                                -- 数据日期
   ,t1.lp_id                                -- 法人编号
   ,t1.cust_id                              -- 客户编号
   ,t1.cust_name                            -- 客户名称
   ,t1.cust_en_name                         -- 客户英文名称
   ,t1.cust_kind_cd						    -- 客户种类代码
   ,t1.open_acct_dt                         -- 开户日期
   ,t1.belong_org_id                        -- 所属机构编号
   ,t1.open_acct_org_id                     -- 开户机构编号
   ,t1.anti_mon_lau_belong_org_id           -- 反洗钱归属机构编号
   ,t1.open_acct_teller_id                  -- 开户柜员编号
   ,nvl(trim(t1.open_acct_chn_cd),'-')      -- 开户渠道代码
   ,nvl(trim(t1.create_chn_cd),'-')         -- 创建渠道代码
   ,t1.cust_mgr_id                          -- 客户经理编号
   ,t1.cust_type_cd                         -- 客户类型代码
   ,t1.crdt_cust_type_cd                    -- 信贷客户类型代码
   ,t1.cust_lev_cd                          -- 客户级别代码
   ,t1.depositr_cate_cd                     -- 存款人类别代码
   ,t1.bal_pay_way_cd                       -- 收支方式代码
   ,nvl(trim(t1.cust_status_cd),'-')        -- 客户状态代码
   ,t1.corp_anl_inco                        -- 企业年收入
   ,t1.corp_year_bus_lmt                    -- 企业年营业额
   ,t1.corp_found_dt                        -- 企业成立日期
   ,t1.corp_size_cd                         -- 企业规模代码
   ,t1.indus_categy_cd                      -- 行业门类代码
   ,nvl(trim(t1.indus_type_cd),'-')         -- 行业类型代码
   ,nvl(trim(t1.indus_type_cd_crdtc),'-')   -- 行业类型代码_征信
   ,t1.phone_crdtc                          -- 联系电话_征信
   ,t1.corp_type_cd                         -- 企业类型代码
   ,t1.cty_rg_cd                            -- 国家和行政区划代码
   ,nvl(trim(t1.rg_cd),'000000')            -- 行政区划代码
   ,t1.econ_char_cd                         -- 经济性质代码
   ,t1.econ_type_cd                         -- 经济类型代码
   ,t1.orgnz_cd                             -- 组织机构代码
   ,nvl(trim(t1.orgnz_type_cd),'00')        -- 组织机构类型代码
   ,t1.natnal_econ_dept_type_cd             -- 国民经济部门类型代码
   ,t1.indus_level5_cls_cd                  -- 行业五级分类代码
   ,t1.indus_crdt_rating_cd                 -- 行业信用评级代码
   ,t1.soci_crdt_cd                         -- 社会信用代码
   ,t1.bus_lics_num                         -- 营业执照号
   ,t1.bus_lics_exp_dt                      -- 营业执照到期日期
   ,t1.nation_tax_rgst_cert_num             -- 国税登记证号码
   ,t1.local_tax_rgst_cert_num              -- 地税登记证号码
   ,t1.fin_lics_num							-- 金融许可证号
   ,t1.pbc_pay_bank_no						-- 人行支付行号
   ,t1.econ_orgnz_form_cd                   -- 经济组织形式代码
   ,t1.loan_card_no                         -- 贷款卡号
   ,t1.stock_cd                             -- 股票代码
   ,t1.oper_range                           -- 经营范围
   ,t1.emply_qtty                           -- 企业员工人数
   ,nvl(trim(t1.curr_cd),'-')               -- 币种代码
   ,t1.rgst_cap                             -- 注册资金
   ,t1.rgst_addr                            -- 注册地址
   ,t1.rgst_dt                              -- 注册日期
   ,t1.rgstion_cd                           -- 登记注册代码
   ,t1.mang_field_prop_cd                   -- 经营场地所有权代码
   ,t1.corp_rgstion_type                    -- 企业登记注册类型
   ,t1.paid_in_capital                      -- 实收资本
   ,nvl(trim(t1.paid_in_capital_curr_cd),'-')  -- 实收资本币种
   ,t1.invtor_cty_cd                        -- 投资方国家代码
   ,t1.mang_field_area                      -- 经营场地面积
   ,t1.asset_tot                            -- 资产总额
   ,t1.net_asset_tot                        -- 净资产总额
   ,t1.single_lp_flg                        -- 独立法人标志
   ,t1.high_new_tech_corp_flg               -- 高新技术企业标志
   ,decode(t1.rela_party_flg, '1', '1', '0')-- 关联方标志
   ,t1.rela_group_type_cd                   -- 关联集团类型代码
   ,t1.lp_org_name                          -- 法人机构名称
   ,t1.lp_org_type_cd                       -- 法人机构类型代码
   ,t1.lp_org_cust_id                       -- 法人机构客户编号
   ,nvl(t1.group_cust_flg,'0')              -- 集团客户标志
   ,nvl(t1.cbrc_sb_flg,'0')                 -- 银监小企业标志
   ,t1.labor_inte_flg						-- 劳动密集型标志
   ,nvl(trim(t1.hold_type_cd),'Z9999')      -- 控股类型代码
   ,t1.off_shore_cust_flg                   -- 离岸客户标志
   ,t1.prit_etp_flg                         -- 民营企业标志
   ,t1.ctysd_corp_flg                       -- 农村企业标志
   ,t1.corp_grow_stage_cd                   -- 企业成长阶段代码
   ,t1.list_corp_type_cd                    -- 上市公司类型代码
   ,t1.strate_new_indus_cls_cd              -- 战略性新兴产业分类代码
   ,t1.list_corp_flg                        -- 上市公司标志
   ,t1.strtg_cust_flg                       -- 战略客户标志
   ,t1.open_cap                             -- 开办资金
   ,t1.crdt_cust_flg                        -- 授信客户标志
   ,t1.stament_flg                          -- 自证声明标志
   ,t1.tax_org_cate_cd                      -- 税收机构类别代码
   ,t1.tax_resdnt_cty_cd                    -- 税收居民国家代码
   ,t1.tax_resdnt_idti_cd                   -- 税收居民身份代码
   ,t1.basic_acct_open_bank_name            -- 基本账户开户行名称
	 ,t1.basic_acct_acct_num                -- 基本账户账号
   ,t1.tax_num								-- 纳税人识别号
   ,t1.tax_num_null_rs_descb			    -- 纳税人识别号空值原因描述
   ,t1.bel_thi_flg                          -- 属于两高行业标志
   ,t1.trast_tax_regi_cert_flg              -- 办理税务登记证标志
   ,t1.cty_key_enterp_flg                   -- 国家重点企业标志
   ,nvl(t1.group_corp_flg, '0')             -- 集团客户标志二
   ,t1.group_cust_id                        -- 集团客户编号
   ,t1.group_type_cd                        -- 集团类型代码
   ,t1.group_parent_corp_id                 -- 集团母公司编号
   ,t1.lmt_or_encrge_indus_cd               -- 限制或鼓励行业代码
   ,t1.have_bod_flg                         -- 有董事会标志
   ,t1.green_crdt_cust_flg                  -- 绿色信贷客户标志
   ,t1.green_crdt_cls_cd                    -- 绿色信贷分类_旧版代码
   ,t1.green_crdt_cls_new                   -- 绿色信贷分类_新版代码
   ,t1.sci_tech_corp_cls_cd                 -- 科技型企业分类代码
   ,t1.sci_tech_corp_idtfy_dt               -- 科技型企业认定日期
   ,t1.edu_hea_flg						    -- 文教健康标志
   ,t1.inc_flg								-- 普惠标志
   ,t1.araf_flg                             -- 三农标志
   ,t1.is_mx_mgmt_righ_flg                  -- 有无进出口经营权标志
   ,t1.escp_debt_corp_flg                   -- 逃废债企业标志
   ,t1.is_mx_oper_item_flg                  -- 有无进出口经营项标志
   ,t1.resdnt_flg       					-- 居民标志
   ,t1.dom_overs_flg                        -- 境内外标志
   ,t1.green_bond_proj_flg                  -- 绿色债券项目标志
   ,t1.work_addr        					-- 办公地址
   ,t1.work_addr_zip_cd 					-- 办公地址邮政编码
   ,t1.posta_addr       					-- 通讯地址
   ,t1.posta_addr_zip_cd					-- 通讯地址邮政编码
   ,t1.prod_mang_addr       				-- 生产经营地址
   ,t1.prod_mang_addr_zip_cd				-- 生产经营地址邮政编码
   ,t1.mang_site_cd                         -- 经营所在地行政区划代码
   ,t1.crdt_cust_risk_rating_cd      		-- 信贷客户风险评级代码
   ,t1.crdt_cust_risk_rating_start_dt		-- 信贷客户风险评级开始日期
   ,t1.crdt_cust_risk_rating_exp_dt  		-- 信贷客户风险评级到期日期
   ,t1.ownsp_type_cd                 		-- 所有制类型代码
   ,t1.dep_class_cust_flg                   -- 存款类客户标志
   ,t1.loan_class_cust_flg                  -- 信贷客户标志代码
   ,t1.guar_class_cust_flg                  -- 担保客户标志代码
   ,t1.corp_close_flg                		-- 企业关停标志
   ,t1.gover_fin_plat_flg                   -- 政府融资平台标志
   ,t1.short_check_blklist_flg              -- 空头支票黑名单标志
   ,t1.fir_lon_dt							-- 首贷日期
   ,t1.orgnz_surviv_status_cd	            -- 组织机构存续状态代码
   ,t1.corp_idti_idf_type_cd	            -- 企业身份标识类型代码
   ,t1.major_contrior_cnt	                -- 主要出资人个数
   ,t1.actl_ctrler_cnt	                    -- 实际控制人个数
   ,t1.fin_dept_phone	                    -- 财务部门联系电话
   ,t1.job_cd                               -- 任务代码
   ,t1.etl_timestamp                        -- etl处理时间戳
  from ${icl_schema}.cmm_corp_cust_basic_info_ex02 t1
 where not exists (select 1 from ${icl_schema}.cmm_corp_cust_basic_info_ex01 t2
 													 where t1.cust_id = t2.cust_id);
commit;


-- 2.2 exchage ex table and target table
alter table ${icl_schema}.cmm_corp_cust_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_corp_cust_basic_info_ex;

-- 2.3 客户号空值检查
whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${icl_schema}.cmm_corp_cust_basic_info 
  	                                where trim(cust_id) is null
  	                                  and etl_dt = to_date('${batch_date}', 'yyyymmdd'));
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'invalid data:cust_id exists null ');
    end if;
  end loop;
end;
/



-- 3.1 drop ex table
whenever sqlerror continue none ;
--drop table ${icl_schema}.cmm_corp_cust_basic_info_ex purge;
--drop table ${icl_schema}.cmm_corp_cust_basic_info_ex01 purge;
--drop table ${icl_schema}.cmm_corp_cust_basic_info_ex02 purge;
--drop table ${icl_schema}.tmp_cmm_corp_cust_basic_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_corp_cust_basic_info_02 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname=>'${icl_schema}',tabname=>'cmm_corp_cust_basic_info',partname=>'p_${batch_date}',estimate_percent=>10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade=>true,force=>true,degree=>8);
